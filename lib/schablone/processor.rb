require "thread"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Logger
    include Celluloid::Notifications

    def initialize
      subscribe("halt", :halt)

      Actor[:navigator] = Navigator.new
      @navigator = Actor[:navigator]

      Actor[:scraper_pool] = Scraper.pool(
        size: Schablone.config.scraper_pool_size
      )
    end

    def navigator
      Actor[:navigator].wrapped_object
    end

    def run(klass)
      step(klass) while navigator.cycle
      halt
    end

    def halt
      info("Navigator is about to terminate.")
      Actor[:navigator].terminate

      info("Scraper pool is about to terminate.")
      Actor[:scraper_pool].terminate

      info("Processor is about to terminate.")
      terminate
    end

    private

    def step(klass)
      uris = Actor[:navigator].current_uris.map do |uri|
        Actor[:scraper_pool].future.scrape(uri, klass)
      end

      uris.each { |uri| Actor[:navigator].stage(*uri.value) }
    end
  end
end
