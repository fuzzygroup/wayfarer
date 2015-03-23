require "uri"
require "thread"

module Scrapespeare
  class Processor

    attr_reader :current_uris
    attr_reader :staged_uris
    attr_reader :cached_uris

    attr_accessor :scraper
    attr_accessor :router

    def initialize(entry_uri, scraper, router)
      @scraper = scraper
      @router  = router
      @fetcher = Fetcher.new
      @result  = []

      @current_uris = [entry_uri]
      @staged_uris  = []
      @cached_uris  = []
    end

    def process
      uri  = next_uri
      page = fetch(uri)
      doc  = page.parsed_document

      page.links.each do |uri|
        stage_uri(uri)
      end

      extract = @scraper.extract(doc)
      @result << extract
    end

    private
    def fetch(uri)
      @fetcher.fetch(uri)
    end

    def next_uri
      @current_uris.shift
    end

    def has_next_uri?
      return true unless @current_uris.empty?
      @staged_uris.any? ? (cycle; true) : false
    end

    def stage_uri(uri)
      unless @cached_uris.include?(uri) or @router.forbids?(uri)
        @staged_uris << uri
      end
    end

    def cache_uri(uri)
      @cached_uris << uri
    end

    def cycle
      @current_uris, @staged_uris = @staged_uris, []
    end

  end
end
