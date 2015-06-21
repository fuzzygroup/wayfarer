require "thread"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Logger

    # finalizer :shutdown_adapter_pool

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
              info("Scraper initiated halt")
              throw(:halt)
            else
              Actor[:navigator].stage(*val)
            end
          end
        end

        info("Nothing left to do. Halting...")
        throw(:halt)
      end

      info("Processor halted")
    end

    private

    def shutdown_adapter_pool
      HTTPAdapters::AdapterPool.shutdown { |adapter| adapter.free }
    end
  end
end
