module Scrapespeare
  class Crawler

    attr_reader :scraper

    def initialize(&proc)
      @scraper = Scraper.new
      @http_adapter = http_adapter
      @parser = Parser

      instance_eval(&proc) if block_given?
    end

    def crawl(uri)
      doc = @parser.parse(fetch(uri))
      @scraper.extract(doc)
    end

    def http_adapter
      case Scrapespeare.config.http_adapter
      when :rest_client then Scrapespeare::HTTPAdapters::RestClientAdapter.new
      when :selenium then Scrapespeare::HTTPAdapters::SeleniumAdapter.new
      else fail "Unknown HTTP adapter `#{Scrapespeare.config.http_adapter}`"
      end
    end

    def scrape(&proc)
      @scraper.instance_eval(&proc) if block_given?
    end

    def configure
      yield Scrapespeare.config if block_given?
    end

    def evaluate(identifier, evaluator = nil, &proc)
      if evaluator
        @scraper.pass_evaluator(identifier, evaluator)
      elsif proc
        @scraper.pass_evaluator(identifier, proc)
      end
    end

    private
    def fetch(uri)
      http_adapter.fetch(uri)
    end

  end
end
