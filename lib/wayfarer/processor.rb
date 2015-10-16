module Wayfarer
  class Processor
    include Celluloid
    include Celluloid::Internals::Logger

    attr_reader :navigator

    def initialize
      @halted = false
      @adapter_pool = HTTPAdapters::AdapterPool.new
      @navigator = Navigator.new

      Wayfarer.log.debug("[#{self}] Spawning Navigator and Scraper pool")
      container.run!
    end

    def halted?
      @halted
    end

    def run(klass)
      while navigator.cycle
        navigator.current_uris.each.lazy
          .map { |uri| scraper_pool.future.scrape(uri, klass, @adapter_pool) }
          .each { |future| handle_future(future) }
      end

      @halted = true

      Wayfarer.log.debug("[#{self}] Terminating Scraper pool")
      scraper_pool.terminate

      Wayfarer.log.debug("[#{self}] Calling post-processors")
      klass.post_process!
    end

    private

    def container
      Class.new(Celluloid::Supervision::Container) do
        pool Scraper,
             as: :scraper_pool,
             size: Wayfarer.config.connection_count
      end
    end

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
        STDERR.puts val.exception.inspect, val.exception.backtrace.join("\n")
      end
    end

    # TODO Print something useful
    def handle_halt(_val)
      @halted = true
    end

    def handle_stage(val)
      navigator.stage(*val.uris)
    end

    def scraper_pool
      Actor[:scraper_pool]
    end
  end
end
