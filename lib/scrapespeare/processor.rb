require "uri"
require "thread"

module Scrapespeare
  class Processor

    attr_reader :staged_uris
    attr_reader :current_uris
    attr_reader :cached_uris
    attr_reader :depth

    def initialize(entry_uri, scraper_table, router)
      @scraper_table = scraper_table
      @router        = router
      @result        = Result.new
      @fetcher       = Fetcher.new
      @mutex         = Mutex.new

      @current_uris = [entry_uri]
      @staged_uris  = []
      @cached_uris  = []
      @depth        = 0
    end

    def process
      fail unless uri = next_uri

      page = fetch(uri)
      links = recognized_links(page.internal_links)
      puts "---------------------------------"
      puts page.links.to_a
      stage_uris(links)
    end

    private
    def next_uri
      @mutex.synchronize { @current_uris.shift }
    end

    def stage_uris(uris)
      @mutex.synchronize { @staged_uris.concat(uris) }
    end

    def cache_uri(uri)
      @mutex.synchronize { @cached_uris << uri }
    end

    def cycle
      @mutex.synchronize do
        @current_uris, @staged_uris = @staged_uris, []
        @depth += 1
      end
    end

    def fetch(uri)
      @fetcher.fetch(uri)
    end

    def recognized_links(uris)
      uris.find_all { |uri| @router.recognizes?(uri) }
    end

  end
end
