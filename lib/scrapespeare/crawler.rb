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

    # Returns the HTTP adapter determined by `config.http_adapter`
    #
    # @return [Scrapespeare::HTTPAdapters::NetHTTPAdapter, Scrapespeare::HTTPAdapters::SeleniumAdapter]
    # @raise [RuntimeError] if `config.http_adapter` is not `:net_http` or `:selenium`
    def http_adapter
      @http_adapter ||= case Scrapespeare.config.http_adapter
      when :faraday then Scrapespeare::HTTPAdapters::FaradayAdapter.new
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

    # Fires a HTTP request against the URI and returns the response body
    #
    # @param [String] uri
    # @return [String]
    def fetch(uri)
      http_adapter.fetch(uri)
    end

    # Parses a string of HTML
    #
    # @param html [String]
    # @return [Nokogiri::HTML::Document]
    def parse_html(html)
      Nokogiri::HTML(html)
    end

  end
end
