module Scrapespeare
  class Crawler

    attr_reader :scraper
    attr_reader :uri

    attr_accessor :uri_template

    def initialize(&proc)
      @scraper = Scraper.new
      @http_adapter = http_adapter
      @parser = Parser

      instance_eval(&proc) if block_given?
    end

    def crawl(uri_or_template_params)
      @uri = case uri_or_template_params
             when String then URI(uri_or_template_params)
             when Hash   then build_base_uri(uri_or_template_params)
             end
    end

    def http_adapter
      case Scrapespeare.config.http_adapter
      when :rest_client then Scrapespeare::HTTPAdapters::RestClientAdapter.new
      when :selenium    then Scrapespeare::HTTPAdapters::SeleniumAdapter.new
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

    def build_base_uri(params)
      params.each { |key, val| params[key] = URI.escape(val.to_s) }
      URI(@uri_template % params)
    end

  end
end
