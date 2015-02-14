require "uri"

module Scrapespeare
  class Paginator

    include Enumerable

    def initialize(scraper, uri)
      @scraper = scraper
      @uri = uri
      @history = []
    end

    def each
      loop do
        @history << @uri
        @doc = fetch_and_parse(@uri)
        yield @scraper.scrape(@doc)
        break unless has_successor_uri?
      end

      if Scrapespeare.config.http_adapter == :selenium
        http_adapter.release_driver
      end
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
    def has_successor_uri?
      !!(@uri = successor_uri)
    end

    def successor_uri
      nil
    end

    def fetch_and_parse(uri)
      parse_html(fetch(uri))
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
