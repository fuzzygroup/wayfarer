require "thread"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Logger

    def initialize
      info("Processor spawning Navigator...")
      Actor[:navigator] = Navigator.new_link

      info("Processor spawning Scraper pool...")
      Actor[:scraper_pool] = Scraper.pool(
        size: Schablone.config.scraper_thread_count
      )
    end

    def run(klass)
      info("Processor runs")

      catch(:halt) do
        while Actor[:navigator].cycle
          return_values = Actor[:navigator].current_uris.map do |uri|
            Actor[:scraper_pool].future.scrape(uri, klass)
          end

          return_values.each do |future|
            val = future.value

            if val == :halt
              throw(:halt)
            else
              Actor[:navigator].stage(*val)
            end
          end
        end

        throw(:halt)
      end

      info("Shutting down scraper pool...")
      Actor[:scraper_pool].terminate

      info("Processor halted")
    end

    private

    def shutdown_adapter_pool
      HTTPAdapters::AdapterPool.shutdown { |adapter| adapter.free }
    end
  end
end
