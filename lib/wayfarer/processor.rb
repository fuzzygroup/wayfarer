# frozen_string_literal: true
require "observer"
require "pp"

module Wayfarer
  # Runs jobs.
  class Processor
    include Observable

    def initialize(config)
      @config = config.dup
      @halted = false
      @mutex = Mutex.new
      @adapter_pool = HTTPAdapters::AdapterPool.new(config)

      trap_signals
    end

    # The frontier.
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
    # @param [*Array<URI>, *Array<String>] uris
    def run(klass, *uris)
      # Class instance variables are local to a class and don't get inherited
      # This enables locals not to intersect with etc pp blaaah
      job = Class.new(klass)

      frontier.stage(*uris)

      Wayfarer.log.debug("[#{self}] About to cycle")

      while !halted? && frontier.cycle
        current_uris = frontier.current_uris

        changed
        notify_observers(:new_cycle, current_uris.count)

        job.run_hook(:before_crawl)

        @threads = Array.new(@config.connection_count) do
          Thread.new do
            loop do
              uri = has_halted = struct = nil

              @mutex.synchronize do
                uri = current_uris.shift
                has_halted = halted?
              end

              break if uri.nil? || has_halted

              @adapter_pool.with do |adapter|
                struct = job.new.invoke(uri, adapter)
              end

              handle_job_result(struct)
            end
          end
        end

        @threads.each(&:join)

        Wayfarer.log.debug("[#{self}] About to cycle")
      end

      job.run_hook(:after_crawl)

      Wayfarer.log.debug("[#{self}] All done")
      @halted = true

      Wayfarer.log.debug("[#{self}] Freeing adapter pool")
      @adapter_pool.free

      untrap_signals
    end

    private

    def handle_job_result(struct)
      changed
      notify_observers(:processed_uri)

      case struct
      when Job::Mismatch then handle_mismatch(struct)
      when Job::Halt     then handle_halt(struct)
      when Job::Stage    then handle_stage(struct)
      when Job::Error    then handle_error(struct)
      end
    end

    def handle_mismatch(mismatch)
      Wayfarer.log.debug("[#{self}] No matching route for #{mismatch.uri}")
    end

    def handle_halt(halt)
      Wayfarer.log.debug("[#{self}] Halt initiated from #{halt.uri}")
      @mutex.synchronize { halt! unless halted? }
    end

    def handle_stage(stage)
      Wayfarer.log.debug("[#{self}] Staging #{stage.uris.count} URIs")
      @mutex.synchronize { @frontier.stage(*stage.uris) unless halted? }
    end

    def handle_error(error)
      Wayfarer.log.debug(
        "[#{self}] Unhandled exception: #{error.exception.inspect}"
      )

      @mutex.synchronize do
        pp error.exception.backtrace if @config.print_stacktraces

        if @config.reraise_exceptions
          Wayfarer.log.debug("[#{self}] Reraising #{error.exception.inspect}")
          raise error.exception
        else
          Wayfarer.log.debug("[#{self}] Swallowing #{error.exception.inspect}")
        end
      end
    end

    def trap_signals
      @cached_sigint_handler = trap(:INT) do
        halt!

        @cached_sigint_handler.try(:call)

        exit(-1)
      end
    end

    def untrap_signals
      trap(:INT) { @cached_sigint_handler.try(:call) }
    end
  end
end
