require "observer"

module Wayfarer
  # Runs jobs
  class Processor
    include Observable

    def initialize(config)
      @config = config
      @halted = false
      @threads = []
      @mutex = Mutex.new
      @adapter_pool = HTTPAdapters::AdapterPool.new(config)

      Wayfarer.log.debug("[#{self}] Spawning scraper pool")
    end

    # Returns the frontier.
    # @return [MemoryFrontier, RedisFrontier]
    def frontier
      @frontier ||= case @config.frontier
                    when :memory
                      Frontiers::MemoryFrontier.new(@config)
                    when :redis
                      Frontiers::RedisFrontier.new(@config)
                    end
    end

    # Whether processing is done.
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

        @workers = @config.connection_count.times.map do
          Thread.new do
            
          end
        end

        futures = frontier.current_uris.map do |uri|
          adapter_pool.with { |adapter| klass.new.invoke(uri, adapter) }
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
  end
end
