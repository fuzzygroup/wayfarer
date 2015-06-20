require "thread"

module Schablone
  class Scraper
    include Celluloid

    def scrape(uri, klass)
      Actor[:navigator].cache(uri)

      HTTPAdapters::AdapterPool.with do |adapter|
        klass.new.invoke(uri, adapter)
      end
    end
  end
end
