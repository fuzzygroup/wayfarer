require "uri"
require "thread"

module Scrapespeare
  class Processor

    def initialize(entry_uri, scraper_table, router)
      @scraper_table = scraper_table
      @router        = router
      @result        = Result.new
      @fetcher       = Fetcher.new
      @mutex         = Mutex.new

      @current_uris   = [entry_uri]
      @staged_uris    = []
      @processed_uris = []
    end

    def process
      page = fetch(next_uri)
      links = recognized_links(page.internal_links)
    end

    private
    def next_uri
      @mutex.synchronize { @current_uris.shift }
    end

    def fetch(uri)
      @fetcher.fetch(uri)
    end

    def recognized_links(uris)
      uris.find_all { |uri| @router.recognizes?(uri) }
    end

  end
end
