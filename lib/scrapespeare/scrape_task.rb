module Scrapespeare
  class ScrapeTask < Thread

    def initialize(uri, scraper, result)
      @uri     = uri
      @scraper = scraper
      @result  = result

      super(self, &:process)
    end

    def process
      page = Fetcher.new.fetch(@uri)
      result = @scraper.extract(page.parsed_document)
      @result << result.to_h
    end

  end
end
