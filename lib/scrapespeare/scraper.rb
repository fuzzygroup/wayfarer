module Scrapespeare
  class Scraper

    include Scrapespeare::Configurable

    # @return [Array<Scrapespeare::Extractor>]
    attr_reader :extractors

    # @param proc [Proc]
    def initialize(&proc)
      set(:http_adapter, :net_http)

      @extractors = []

      instance_eval &proc if block_given?
    end

    # Initializes and adds an Extractor to {#extractors}
    # @param (see Scrapespeare::Extractor#initialize)
    def add_extractor(identifier, selector, options = {}, &proc)
      @extractors << Scrapespeare::Extractor.new(
        identifier, selector, options, &proc
      )
    end

    # Reduces its {#extractors} returned extracts to a Hash
    #
    # @param (see #fetch)
    # @return [Hash]
    # @see Scrapespeare::Extractor#extract
    def scrape(uri)
      response_body = fetch(uri)
      parsed_document = parse_html(response_body)

      @extractors.reduce(Hash.new) do |hash, extractor|
        hash.merge(extractor.extract(parsed_document))
      end
    end

    private

    # Returns a concrete HTTP adapter determined by <code>@options[:http_adapter]</code>
    # @return [Scrapespeare::HTTPAdapters::NetHTTPAdapter, Scrapespeare::HTTPAdapters::SeleniumAdapter]
    # @raise [RuntimeError] if <code>@options[:http_adapter]</code> is not +:net_http+ or +:selenium+
    def http_adapter
      case @options[:http_adapter]
      when :net_http
        Scrapespeare::HTTPAdapters::NetHTTPAdapter
      when :selenium
        Scrapespeare::HTTPAdapters::SeleniumAdapter
      else
        fail "Unknown HTTP adapter `#{@options[:http_adapter]}`"
      end
    end

    # Fires a HTTP request against the URI and returns the response body
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

    # Initializes and adds a nested Extractor by calling {#add_extractor}
    #
    # @param identifier [Symbol]
    # @param selector [Symbol]
    # @param attributes [Array<String>]
    # @param proc [Proc]
    # @see #add_extractor
    def method_missing(identifier, selector, *attributes, &proc)
      add_extractor(identifier, selector, *attributes, &proc)
    end

  end
end
