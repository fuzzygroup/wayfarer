require "thread"

module Scrapespeare
  class ScrapeTask < Thread

    def initialize(uri, scraper, result)
      @uri     = uri
      @scraper = scraper
      @result  = result
      @mutex   = Mutex.new

      super(self, &:process)
    end

    def process
      page = Fetcher.new.fetch(@uri)
      result = @scraper.extract(page.parsed_document)

      @mutex.synchronize { @result << result.to_h }
    end

  end
end
