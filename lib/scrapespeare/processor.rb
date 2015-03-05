require "set"
require "thread/pool"

module Scrapespeare
  class Processor

    attr_reader :staged_uris
    attr_reader :cached_uris

    def initialize(entry_uri, scraper)
      @scraper      = scraper
      @staged_uris  = [entry_uri]
      @cached_uris  = []
      @result       = Result.new
      @pool         = Thread.pool(4)
      @mutex        = Mutex.new
    end

    def run
      @pool.process(&:process)
      @result
    end

    def process
      if @staged_uris.empty?
        @pool.shutdown
        return
      end

      uri    = @staged_uris.shift
      page   = Fetcher.new.fetch(uri)
      result = @scraper.extract(page.parsed_document)

      cache_uri(uri)
      stage_uris(page.internal_links)
    end

    private
    def stage_uris(uris)
      @mutex.synchronize do
        new_uris = uris.reject { |uri| @cached_uris.include? uri }
        @staged_uris.concat(new_uris)
      end
    end

    def cache_uri(uri)
      @mutex.synchronize { @cached_uris.push(uri) }
    end

    def update_result(extract)
    end

  end
end
