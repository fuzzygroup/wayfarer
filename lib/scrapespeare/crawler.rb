module Scrapespeare
  class Crawler

    attr_reader :scraper

    def initialize
      @scraper = Scraper.new
    end

    def crawl(uri)
      paginator = Paginator.new(@scraper, uri)

      @scraper.scrape(uri)
    end

    private
    def scrape(&proc)
      @scraper.instance_eval(&proc) if block_given?
    end

    def config
      yield Scrapespeare.config if block_given?
    end

  end
end
