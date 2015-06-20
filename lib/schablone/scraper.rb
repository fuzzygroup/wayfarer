require "thread"

module Schablone
  class Scraper
    include Celluloid
    include Celluloid::Logger

    def scrape(uri, klass)
      HTTPAdapters::AdapterPool.with do |adapter|
        indexer = klass.new
        indexer.invoke(uri, adapter)
      end

    rescue => error
      error("Scraping #{uri} failed: #{error}")
      []
    end
  end
end
