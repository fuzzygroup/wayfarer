require "uri"
require "thread"

module Scrapespeare
  class Processor

    attr_reader :current_uris
    attr_reader :staged_uris
    attr_reader :cached_uris

    attr_reader :result

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

    def run
      process while has_next_uri?
    end

    def process
      uri  = next_uri
      page = fetch(uri)
      doc  = page.parsed_document

      cache_uri(uri)

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
      return false if @cached_uris.include?(uri) ||
                      @staged_uris.include?(uri) ||
                      @router.forbids?(uri)

      @staged_uris << uri
    end

    def cache_uri(uri)
      @cached_uris << uri
    end

    def cycle
      @current_uris, @staged_uris = @staged_uris, []
    end

  end
end
