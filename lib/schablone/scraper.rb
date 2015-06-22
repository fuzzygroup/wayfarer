require "thread"
require "pp"

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
      return Task::Error.new(error)
    end
  end
end
