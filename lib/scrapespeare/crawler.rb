module Scrapespeare
  class Crawler

    def initialize
      @scraper = Scraper.new
    end

    def crawl(uri)
      paginator = Paginator.new(@scraper, uri)

      paginator.reduce(Hash.new) do |hash, extract|
        hash.merge(extract)
      end
    end

    private
    def scrape(&proc)
      @scraper.instance_eval(&proc) if block_given?
    end

  end
end
