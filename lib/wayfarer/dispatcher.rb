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

      adapter = adapter_pool.checkout

      job_instance = job.new
      job_instance.page = adapter.fetch(uri)
      job_instance.adapter = adapter
      job_instance.params = params

      begin
        job_instance.public_send(action)
      rescue => exception
        return Error.new(exception)
      end

      if job_instance.halts?
        Halt.new(uri, action)
      else
        Stage.new(job_instance.staged_uris)
      end
    rescue Net::ReadTimeout, Errno::ECONNREFUSED => exception
      # The PhantomJS Selenium driver raises these when its client session times
      # out
      raise exception unless adapter.is_a? HTTPAdapters::SeleniumAdapter

      Wayfarer.log.info("[#{self}] PhantomJS Selenium driver client timed out!")

      adapter.reload!

    rescue HTTPAdapters::NetHTTPAdapter::MalformedURI
      Wayfarer.log.info("[#{self}] Encountered malformed URI: #{uri}")

    rescue HTTPAdapters::NetHTTPAdapter::MalformedRedirectURI
      Wayfarer.log.info("[#{self}] Encountered malformed redirect URI: #{uri}")

    rescue HTTPAdapters::NetHTTPAdapter::MaximumRedirectCountReached
      Wayfarer.log.info("[#{self}] Maximum redirect count reached @ #{uri}")

    ensure
      adapter_pool.checkin
    end
  end
end
