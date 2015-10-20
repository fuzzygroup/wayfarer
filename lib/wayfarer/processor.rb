require "observer"

module Wayfarer
  # Runs jobs
  class Processor
    include Observable

    include Celluloid

    task_class Task::Threaded

    def initialize(config)
      @config = config
      @uuid = config.uuid
      @halted = false
      @adapter_pool = HTTPAdapters::AdapterPool.new(config)

      Wayfarer.log.debug("[#{self}] Spawning scraper pool")
      container.run!
    end

    # Returns the frontier.
    # @return [MemoryFrontier, RedisFrontier]
    def frontier
      Celluloid::Actor[:frontier] ||= case @config.frontier
                                      when :memory
                                        Frontiers::MemoryFrontier.new(@config)
                                      when :redis
                                        Frontiers::RedisFrontier.new(@config)
                                      end
    end

    # Whether processing is finished.
    # @return [true, false]
    def halted?
      @halted
    end

    # Sets a halt flag and frees the frontier.
    def halt!
      @halted = true
      frontier.free
    end

    # Runs a job.
    # @param [Job] klass the job to run.
    def run(klass)
      while frontier.cycle
        changed
        notify_observers(:new_cycle, frontier.current_uris.count)

        futures = frontier.current_uris.map do |uri|
          scraper_pool.future.scrape(uri, klass, @adapter_pool)
        end

        futures.each do |future|
          handle_future(future)

          changed
          notify_observers(:processed_uri)
        end
      end

      @halted = true

      Wayfarer.log.debug("[#{self}] Terminating workers")
      worker_pool.terminate

      Wayfarer.log.debug("[#{self}] Freeing adapter pool")
      @adapter_pool.free
    end

    private

    def container
      config = @config

      Class.new(Celluloid::Supervision::Container) do
        pool Worker,
             as: :worker_pool,
             size: config.connection_count
      end
    end

    def handle_future(future)
      return if halted?

      case (val = future.value)
      when Job::Mismatch then handle_mismatch(val)
      when Job::Error    then handle_error(val)
      when Job::Halt     then handle_halt(val)
      when Job::Stage    then handle_stage(val)
      end
    end

    def handle_mismatch(val)
      Wayfarer.log.debug("[#{self}] No route for URI: #{val.uri}")
    end

    def handle_error(val)
      if @config.reraise_exceptions
        fail(val.exception)
      elsif @config.print_stacktraces
        STDERR.puts val.exception.inspect, val.exception.backtrace.join("\n")
      end
    end

    def handle_halt(*)
      @halted = true
    end

    def handle_stage(val)
      frontier.async.stage(*val.uris)
    end

    def scraper_pool
      Actor[:worker_pool]
    end
  end
end
