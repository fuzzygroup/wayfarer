require "observer"

module Wayfarer
  # Runs jobs
  class Processor
    include Observable

    def initialize(config)
      @config = config.dup
      @halted = false
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
    # @param [*Array<URI>, *Array<String>] *uris
    def run(klass, *uris)
      frontier.stage(*uris)

      while frontier.cycle
        current_uris = frontier.current_uris

        changed
        notify_observers(:new_cycle, current_uris.count)

        workers = @config.connection_count.times.map do
          Thread.new do
            loop do
              uri = has_halted = struct = nil

              @mutex.synchronize do
                uri = current_uris.shift
                has_halted = halted?
              end

              puts "URI: #{uri}"

              break if !uri || has_halted

              @adapter_pool.with do |adapter|
                struct = klass.new.invoke(uri, adapter)
              end

              handle_job_result(struct)

              changed
              notify_observers(:processed_uri)
            end
          end
        end

        workers.each(&:join)
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
        @mutex.synchronize { halt! }

      when Job::Stage
        Wayfarer.log.debug("[#{self}] Staging #{struct.uris.count} URIS")
        @mutex.synchronize { @frontier.stage(*struct.uris) }

      when Job::Error
        @mutex.synchronize do
          if @config.print_stacktraces
            Wayfarer.log.debug("[#{self}] Unhandled exception: #{struct.backtrace}")
          elsif @config.reraise_exceptions
            raise struct.exception
          end
        end
      end
    end
  end
end
