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
    def run(klass, *uris)
      frontier.stage(*uris)

      while frontier.cycle
        changed
        notify_observers(:new_cycle, frontier.current_uris.count)

        Wayfarer.log.debug("[#{self}] LEL")

        @workers = @config.connection_count.times.map do
          Thread.new do
            Wayfarer.log.info("THREAD!")
            @mutex.synchronize do
              uri = frontier.current_uris.shift
              Thread.stop if not uri or halted?
            end

            @adapter_pool.with do |adapter|
              ret_val = klass.new.invoke(uri, adapter)
            end

            handle_job_result(ret_val)

            changed
            notify_observers(:processed_uri)
          end
        end

        Wayfarer.log.debug("[#{self}] WAITING")
        @workers.each(&:join)
      end

      Wayfarer.log.debug("[#{self}] All done")
      @halted = true

      Wayfarer.log.debug("[#{self}] Freeing adapter pool")
      @adapter_pool.free
    end

    private

    def handle_job_result(ret_val)
      case ret_val
      when Mismatch then
      end
    end
  end
end
