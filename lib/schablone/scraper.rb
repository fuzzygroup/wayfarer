require "thread"

module Schablone
  class Scraper
    include Celluloid

    def scrape(uri, klass)
      HTTPAdapters::AdapterPool.with do |adapter|
        klass.new.invoke(uri, adapter)
      end
    end
  end
end
