require "thread"
require "connection_pool"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Logger

    finalizer :shutdown_scraper_pool
    finalizer :shutdown_adapter_pool

    attr_reader :adapter_pool

    def initialize
      Schablone.log.info("[#{self}] Processor spawned")

      @pool_size = Schablone.config.scraper_thread_count

      Schablone.log.info("[#{self}] Instantiating HTTP adapter pool")
      instantiate_adapter_pool

      Schablone.log.info("[#{self}] Spawning Navigator")
      Actor[:navigator] = Navigator.new_link

      Schablone.log.info("[#{self}] Spawning Scraper pool")
      Actor[:scraper_pool] = Scraper.pool(size: @pool_size)
    end

    def run(klass)
      catch(:halt) do
        while navigator.cycle
          info("[#{self}] Navigator cycled")

          futures = navigator.current_uris.map do |uri|
            scraper_pool.future.scrape(uri, klass)
          end

          futures.each do |future|
            case (val = future.value)
            when Task::Mismatch
              Schablone.log.info("[#{self}] No route for URI: #{val.uri}")
            when Task::Error
              if Schablone.config.reraise_exceptions
                raise(val.exception)
              elsif Schablone.config.print_stacktraces
                puts val.exception.inspect, val.exception.backtrace.join("\n")
              end
            when Task::Halt
              Schablone.log.info("[#{self}] Halt initiated by ##{val.method}")
              throw(:halt)
            when Task::Stage
              navigator.async.stage(*val.uris)
            end
          end
        end

        throw(:halt)
      end

      Schablone.log.info("[#{self}] Terminating Scraper pool")
      scraper_pool.terminate

      Schablone.log.info("[#{self}] Calling post-processors")
      klass.post_process!
    end

    def shutdown_adapter_pool
      @adapter_pool.shutdown { |adapter| adapter.free }
    end

    def shutdown_scraper_pool
      Schablone.log.info("Shutting down scraper pool...")
      Actor[:scraper_pool].terminate
    end

    private

    def navigator
      Actor[:navigator]
    end

    def scraper_pool
      Actor[:scraper_pool]
    end

    def instantiate_adapter_pool
      @adapter_pool = ConnectionPool.new(size: 16, timeout: 5) do
        case Schablone.config.http_adapter
        when :net_http then Schablone::HTTPAdapters::NetHTTPAdapter.instance
        when :selenium then Schablone::HTTPAdapters::SeleniumAdapter.new
        end
      end
    end
  end
end
