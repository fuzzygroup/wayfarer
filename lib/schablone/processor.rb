require "thread"
require "connection_pool"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Logger

    finalizer :shutdown_scraper_pool

    attr_reader :adapter_pool

    class ProcessorGroup < Celluloid::SupervisionGroup
      supervise Navigator,
        as: :navigator

      pool Scraper,
        as: :scraper_pool,
        size: 6
    end

    def initialize
      @halted = false

      Schablone.log.info("[#{self}] Spawning Navigator and Scraper pool")
      ProcessorGroup.run!
    end

    def halted?
      @halted
    end

    def run(klass)
      while navigator.cycle
        futures = navigator.current_uris.map do |uri|
          scraper_pool.future.scrape(uri, klass)
        end

        futures.each { |future| handle_future(future) }
      end

      @halted = true

      Schablone.log.info("[#{self}] Terminating Scraper pool")
      scraper_pool.terminate

      Schablone.log.info("[#{self}] Calling post-processors")
      klass.post_process!
    end

    def shutdown_scraper_pool
      Schablone.log.info("Shutting down scraper pool...")
      Actor[:scraper_pool].terminate
    end

    private

    def handle_future(future)
      return if @halted

      case (val = future.value)
      when Task::Mismatch then handle_mismatch(val)
      when Task::Error    then handle_error(val)
      when Task::Halt     then handle_halt(val)
      when Task::Stage    then handle_stage(val)
      end
    end

    def handle_mismatch(val)
      Schablone.log.info("[#{self}] No route for URI: #{val.uri}")
    end

    def handle_error(val)
      if Schablone.config.reraise_exceptions
        raise(val.exception)
      elsif Schablone.config.print_stacktraces
        puts val.exception.inspect, val.exception.backtrace.join("\n")
      end
    end

    def handle_halt(val)
      @halted = true
    end

    def handle_stage(val)
      navigator.async.stage(*val.uris)
    end

    def navigator
      Actor[:navigator]
    end

    def scraper_pool
      Actor[:scraper_pool]
    end
  end
end
