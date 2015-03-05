require "thread/pool"

module Scrapespeare
  class Processor

    attr_reader :staged
    attr_reader :cached

    def initialize(entry_uri, scraper)
      @scraper = scraper
      @staged  = [entry_uri]
      @cached  = []
      @result  = Result.new

      @mutex = Mutex.new
    end

    def process
      uri    = @staged.shift
      page   = Fetcher.new.fetch(uri)
      result = @scraper.extract(page.parsed_document)

      cache_uri(uri)
      stage_uris(page.internal_links)
    end

    private
    def stage_uris(uris)
      @mutex.synchronize { @staged.concat(uris) }
    end

    def cache_uri(uri)
      @mutex.synchronize { @cached << uri }
    end

  end
end
