require "thread"

module Wayfarer
  class Scraper
    include Celluloid
    include Celluloid::Logger

    def initialize
      debug("[#{self}] Scraper spawned")
    end

    def scrape(uri, klass, adapter_pool)
      adapter_pool.with do |adapter|
        debug("[#{self}] About to scrape: #{uri}")
        indexer = klass.new
        indexer.invoke(uri, adapter)
      end
    end
  end
end
