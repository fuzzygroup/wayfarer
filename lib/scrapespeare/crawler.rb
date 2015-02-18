module Scrapespeare
  class Crawler

    attr_reader :scraper

    def initialize(&proc)
      @scraper = Scraper.new
      instance_eval(&proc) if block_given?
    end

    def crawl(uri)
      doc = parse(fetch(uri))
      @scraper.scrape(doc)
    end

    def http_adapter
      @http_adapter ||= case Scrapespeare.config.http_adapter
      when :rest_client then Scrapespeare::HTTPAdapters::RestClientAdapter.new
      when :selenium then Scrapespeare::HTTPAdapters::SeleniumAdapter.new
      else fail "Unknown HTTP adapter `#{Scrapespeare.config.http_adapter}`"
      end
    end

    private
    def scrape(&proc)
      @scraper.instance_eval(&proc) if block_given?
    end

    def config
      yield Scrapespeare.config if block_given?
    end

    def fetch(uri)
      http_adapter.fetch(uri)
    end

    def parse(html)
      Nokogiri::HTML(html)
    end

  end
end
