require "thread/pool"

module Scrapespeare
  class Processor

    attr_reader :staged

    def initialize(entry_uri, scraper)
      @scraper = scraper
      @staged  = [entry_uri]
      @result  = Result.new
    end

    def process
      uri    = @staged.shift
      page   = Fetcher.new.fetch(uri)
      result = @scraper.extract(page.parsed_document)

      stage_uris(page.internal_links)
    end

    private
    def stage_uris(uris)
      @staged.concat(uris)
    end

  end
end
