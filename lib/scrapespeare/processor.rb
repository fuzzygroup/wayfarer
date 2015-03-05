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

      @pool    = Thread.pool(4)
      @mutex   = Mutex.new
    end

    def run
      @pool.process(&:process)
      @result
    end

    def process
      if @staged.empty?
        @pool.shutdown
        return
      end

      uri    = @staged.shift
      page   = Fetcher.new.fetch(uri)
      result = @scraper.extract(page.parsed_document)

      cache_uri(uri)
      stage_uris(page.internal_links)
    end

    private
    def stage_uris(uris)
      @mutex.synchronize do
        new_uris = uris.reject { |uri| @cached.include? uri }
        @staged.concat(new_uris)
      end
    end

    def cache_uri(uri)
      @mutex.synchronize { @cached.push(uri) }
    end

    def update_result(extract)
    end

  end
end
