require "uri"
require "thread"

module Scrapespeare
  class Processor

    def initialize(scraper, router)
      @scraper = scraper
      @router  = router
      @fetcher = Fetcher.new

      @current_uris = []
      @staged_uris  = []
      @cached_uris  = []
    end

    def process
    end

    private
    def fetch(uri)
      @fetcher.fetch(uri)
    end

    def next_uri
      
    end

  end
end
