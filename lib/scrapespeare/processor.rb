require "uri"
require "thread"
require "thread/pool"

module Scrapespeare
  class Processor

    attr_reader :current_uris
    attr_reader :staged_uris
    attr_reader :cached_uris
    attr_reader :result

    def initialize(entry_uri, scraper, router)
      @scraper = scraper
      @router  = router
      @fetcher = Fetcher.new
      @result  = []

      @current_uris = [entry_uri]
      @staged_uris  = []
      @cached_uris  = []

      @pool  = Thread.pool(4)
      @mutex = Mutex.new
    end

    def run
      @pool.process { step while has_next_uri? }
      @pool.shutdown
    end

    def step
      uri  = next_uri
      page = fetch(uri)
      doc  = page.parsed_document

      cache_uri(uri)

      page.links.each { |uri| stage_uri(uri) }

      extract = @scraper.extract(doc)
      @result << extract
    end

    private
    def fetch(uri)
      @fetcher.fetch(uri)
    end

    def next_uri
      @mutex.synchronize { @current_uris.shift }
    end

    def has_next_uri?
      @mutex.synchronize do
        return true unless @current_uris.empty?
        @staged_uris.any? ? (cycle; true) : false
      end
    end

    def stage_uri(uri)
      @mutex.synchronize do
        return false if @current_uris.include?(uri) ||
                        @staged_uris.include?(uri)  ||
                        @cached_uris.include?(uri)  ||
                        @router.forbids?(uri)

        @staged_uris << uri
      end
    end

    def cache_uri(uri)
      @mutex.synchronize { @cached_uris << uri }
    end

    def cycle
      @current_uris, @staged_uris = @staged_uris, []
    end

  end
end
