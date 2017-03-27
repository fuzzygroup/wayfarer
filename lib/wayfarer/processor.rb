# frozen_string_literal: true
require "observer"
require "pp"

module Wayfarer
  # Runs jobs.
  class Processor
    include Observable

    def initialize(config)
      @dispatcher = Dispatcher.new(config)
      @config = config.dup
      @halted = false
      @mutex = Mutex.new
    end

    # @return [Frontier]
    def frontier
      @frontier ||= case @config.frontier
                    when :memory
                      Frontiers::MemoryFrontier.new(@config)
                    when :redis
                      Frontiers::RedisFrontier.new(@config)
                    when :memory_bloom
                      Frontiers::MemoryBloomfilter.new(@config)
                    when :redis_bloom
                      Frontiers::RedisBloomfilter.new(@config)
                    else
                      Frontiers::MemoryTrieFrontier.new(@config)
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
      trap_signals

      job = klass.dup
      job.router = klass.router.clone
      job.locals = klass.locals.clone

      frontier.stage(*uris)

      Wayfarer.log.info("[#{self}] First cycle")
      Wayfarer.log.info("[#{self}] Frontier: #{frontier}")

      while !halted? && frontier.cycle
        Wayfarer.log.info("[#{self}] Current: #{frontier.current_uris.count}")

        current_uris = frontier.current_uris # Expensive call!

        changed
        notify_observers(:new_cycle, current_uris.count)

        job.run_hook(:before_crawl)

        @threads = Array.new(@config.connection_count) do
          Thread.new do
            loop do
              uri = has_halted = nil

              @mutex.synchronize do
                uri = current_uris.shift
                has_halted = halted?
              end

              break if uri.nil? || has_halted

              handle_dispatch_result(@dispatcher.dispatch(job, uri))
            end
          end
        end

        @threads.each(&:join)

        Wayfarer.log.info("[#{self}] About to cycle")
        Wayfarer.log.info("[#{self}] Staged: #{frontier.staged_uris.count}")
      end

      job.run_hook(:after_crawl)

      Wayfarer.log.debug("[#{self}] All done")
      @halted = true
    ensure
      untrap_signals

      Wayfarer.log.debug("[#{self}] Freeing frontier")
      frontier.free

      Wayfarer.log.debug("[#{self}] Freeing adapter pool")
      @dispatcher.adapter_pool.free
    end

    private

    def handle_dispatch_result(result)
      changed
      notify_observers(:processed_uri)

      case result
      when Dispatcher::Mismatch then handle_mismatch(result)
      when Dispatcher::Halt     then handle_halt(result)
      when Dispatcher::Stage    then handle_stage(result)
      when Dispatcher::Error    then handle_error(result)
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
      Wayfarer.log.error(
        "[#{self}] Unhandled exception: #{error.exception.inspect}"
      )

      @mutex.synchronize do
        if @config.print_stacktraces
          STDERR.puts PP.pp(error.exception.backtrace)
        end

        if @config.reraise_exceptions
          Wayfarer.log.error("[#{self}] Reraising #{error.exception.inspect}")
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
