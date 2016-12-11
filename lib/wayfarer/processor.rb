require "observer"

module Wayfarer
  # Runs jobs
  class Processor
    include Observable

    def initialize(config)
      @config = config.dup
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

        @workers = @config.connection_count.times.map do
          Thread.new do
            loop do
              uri = struct = nil

              @mutex.synchronize do
                uri = frontier.current_uris.shift
                break if not uri or halted?
              end

              @adapter_pool.with do |adapter|
                struct = klass.new.invoke(uri, adapter)
              end

              handle_job_result(struct)

              changed
              notify_observers(:processed_uri)
            end
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

    def handle_job_result(struct)
      case struct
      when Job::Mismatch
        Wayfarer.log.debug("[#{self}] No matching route for #{struct.uri}")

      when Job::Halt
        Wayfarer.log.debug("[#{self}] Halt initiated from #{struct.uri}")
        halt!

      when Job::Stage
        @mutex.synchronize { @frontier.stage(*struct.uris) }

      when Job::Error
        @mutex.synchronize do
          if @config.print_stacktraces
            Wayfarer.log.debug("[#{self}] Halt initiated from #{struct.uri}")
          elsif @config.reraise_exceptions
            raise struct.exception
          end
        end
      end
    end
  end
end
