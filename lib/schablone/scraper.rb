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
      raise(error) if Schablone.config.reraise_exceptions
      error("Exception raised while scraping #{uri}: #{error.inspect}")
      puts error.backtrace.join("\n") if Schablone.config.print_stacktraces
      return []
    end
  end
end
