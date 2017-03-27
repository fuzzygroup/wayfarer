# frozen_string_literal: true
module Wayfarer
  # Creates job instances, retrieves pages and, if an URI matches a route, calls
  # methods on the instances.
  class Dispatcher
    # Result types that a {Processor} operates upon.
    Mismatch = Struct.new(:uri)
    Halt     = Struct.new(:uri, :method)
    Stage    = Struct.new(:uris)
    Error    = Struct.new(:exception)

    # @!attribute [r] adapter_pool
    # @return [AdapterPool]
    attr_reader :adapter_pool

    def initialize(config)
      @adapter_pool = HTTPAdapters::AdapterPool.new(config)
    end

    # Dispatches this URI. Matches an URI against the rules of the job's router.
    # If a rule matches, the page is retrieved, and the action associated with
    # the route is called.
    #
    # @param [Job] job
    # @param [URI] uri
    def dispatch(job, uri)
      action, params = job.router.route(uri)
      return Mismatch.new(uri) unless action

      Wayfarer.log.debug("[#{self}] Dispatching to ##{action}: #{uri}")

      job_instance = job.new

      adapter_pool.with do |adapter|
        job_instance.page = adapter.fetch(uri)
        job_instance.adapter = adapter
        job_instance.params = params

        begin
          job_instance.public_send(action)
        rescue => exception
          return Error.new(exception)
        end
      end

      if job_instance.halts?
        Halt.new(uri, action)
      else
        Stage.new(job_instance.staged_uris)
      end
    # What follows are exceptions whose origin I don't care about at the moment
    rescue Net::HTTP::Persistent::Error
      Wayfarer.log.warn("[#{self}] Connection reset by peer: #{uri}")

    rescue Errno::EHOSTUNREACH
      Wayfarer.log.warn("[#{self}] Host unreachable: #{uri}")

    rescue Errno::ENETUNREACH
      Wayfarer.log.warn("[#{self}] No route to network present: #{uri}")

    rescue Net::OpenTimeout, Net::ReadTimeout
      Wayfarer.log.warn("[#{self}] ::Net timeout while processing: #{uri}")

    # SSL verification failed due to a missing certificate
    rescue OpenSSL::SSL::SSLError
      Wayfarer.log.warn("[#{self}] SSL verification failed for: #{uri}")

    # Ruby/zlib encountered a Z_DATA_ERROR.
    # Usually if a stream was prematurely freed.
    # Probably has to do with net-http-persistent
    rescue Zlib::DataError
      Wayfarer.log.warn("[#{self}] Z_DATA_ERROR")

    rescue HTTPAdapters::NetHTTPAdapter::MalformedURI, URI::InvalidURIError
      Wayfarer.log.info("[warn#{self}] Malformed URI: #{uri}")

    rescue HTTPAdapters::NetHTTPAdapter::MalformedRedirectURI
      Wayfarer.log.info("[#{self}] Malformed redirect URI from: #{uri}")

    rescue HTTPAdapters::NetHTTPAdapter::MaximumRedirectCountReached
      Wayfarer.log.info("[#{self}] Maximum redirect count reached @ #{uri}")
    end
  end
end
