module Wayfarer
  class Processor
    include Celluloid
    include Celluloid::Logger

    class ProcessorGroup < Celluloid::SupervisionGroup
      supervise Navigator, as: :navigator
      pool Scraper, as: :scraper_pool, size: Wayfarer.config.connection_count
    end

    def initialize
      @halted = false
      @adapter_pool = HTTPAdapters::AdapterPool.new

      Wayfarer.log.debug("[#{self}] Spawning Navigator and Scraper pool")
      ProcessorGroup.run!
    end

    def halted?
      @halted
    end

    def run(klass)
      while navigator.cycle
        futures = navigator.current_uris.map do |uri|
          scraper_pool.future.scrape(uri, klass, @adapter_pool)
        end

        futures.each { |future| handle_future(future) }
      end

      @halted = true

      Wayfarer.log.debug("[#{self}] Terminating Scraper pool")
      scraper_pool.terminate

      Wayfarer.log.debug("[#{self}] Calling post-processors")
      klass.post_process!
    end

    private

    def handle_future(future)
      return if @halted

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
      if Wayfarer.config.reraise_exceptions
        fail(val.exception)
      elsif Wayfarer.config.print_stacktraces
        puts val.exception.inspect, val.exception.backtrace.join("\n")
      end
    end

    def handle_halt(_val)
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
