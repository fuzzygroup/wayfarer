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
      @pool_size = Schablone.config.scraper_thread_count

      instantiate_adapter_pool

      info("Processor spawning Navigator...")
      Actor[:navigator] = Navigator.new_link

      info("Processor spawning Scraper pool...")
      Actor[:scraper_pool] = Scraper.pool(size: @pool_size)
    end

    def run(klass)
      info("Processor runs")

      while navigator.cycle
        uri_count = navigator.current_uris.count
        info("About to scrape #{uri_count} URI(s)")

        futures = navigator.current_uris.map do |uri|
          scraper_pool.future.scrape(uri, klass)
        end

        futures.each do |future|
          case (val = future.value)
          when Task::Mismatch
          when Task::Error
            if Schablone.config.reraise_exceptions
              raise(val.exception)
            elsif Schablone.config.print_stacktraces
              puts val.exception.inspect, val.exception.backtrace.join("\n")
            end
          when Task::Halt
            break
          when Task::Stage
            navigator.stage(*val.uris)
          end
        end
      end

      info("Processor ran successfully")
    end

    def shutdown_adapter_pool
      @adapter_pool.shutdown { |adapter| adapter.free }
    end

    def shutdown_scraper_pool
      info("Shutting down scraper pool...")
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
