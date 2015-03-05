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

      staged.concat(page.internal_links)
    end

    private
    def stage_uri(uri)
      @staged << uri
    end

  end
end
