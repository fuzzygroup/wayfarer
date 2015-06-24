require "thread"
require "pp"

module Schablone
  class Scraper
    include Celluloid
    include Celluloid::Logger

    def initialize
      info("[#{self}] Scraper spawned")
    end

    def scrape(uri, klass)
      HTTPAdapters::AdapterPool.with do |adapter|
        info("[#{self}] About to scrape: #{uri}")
        indexer = klass.new
        indexer.invoke(uri, adapter)
      end
    end
  end
end
