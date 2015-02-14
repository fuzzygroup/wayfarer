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

  end
end
