module Scrapespeare
  class ScrapeTask < Thread

    def initialize(uri, result)
      @uri    = uri
      @result = result

      super(self, &:process)
    end

    def process
      page = Fetcher.new.fetch(@uri)
      @result << { foo: page.body }
    end

  end
end
