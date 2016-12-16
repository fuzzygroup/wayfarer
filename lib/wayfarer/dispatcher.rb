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
      action, @params = job.router.route(uri)
      return Mismatch.new(uri) unless action

      Wayfarer.log.debug("[#{self}] Dispatching to ##{action}: #{uri}")

      @adapter_pool.with do |adapter|
        job_instance = job.new
        job_instance.page = adapter.fetch(uri)
        job_instance.adapter = adapter
        job_instance.public_send(action)

        if job_instance.halts?
          Halt.new(uri, action)
        else
          Stage.new(job_instance.staged_uris)
        end
      end

    rescue => error
      return Error.new(error)
    end
  end
end
