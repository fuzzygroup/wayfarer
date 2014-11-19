module Scrapespeare
  class Scraper

    include Scrapespeare::Configurable
    include Scrapespeare::Extractable

    # @param proc [Proc]
    def initialize(&proc)
      set(:http_adapter, :net_http)

      instance_eval(&proc) if block_given?
    end

    # Reduces its {#extractors} returned extracts to a Hash
    #
    # @param (see #fetch)
    # @return [Hash]
    # @see Scrapespeare::Extractor#extract
    def scrape(uri)
      response_body = fetch(uri)
      parsed_document = parse_html(response_body)

      result = extractables.reduce(Hash.new) do |hash, extractable|
        hash.merge(extractable.extract(parsed_document))
      end

      result.taint
    end

  private

    # Returns and/or sets `@http_adapter` TODO
    #
    # @return [Scrapespeare::HTTPAdapters::NetHTTPAdapter, Scrapespeare::HTTPAdapters::SeleniumAdapter]
    # @raise [RuntimeError] if `@options[:http_adapter]` is not `:net_http` or `:selenium`
    def http_adapter
      return @http_adapter if @http_adapter

      case @options[:http_adapter]
      when :net_http
        @http_adapter = Scrapespeare::HTTPAdapters::NetHTTPAdapter.new
      when :selenium
        @http_adapter = Scrapespeare::HTTPAdapters::SeleniumAdapter.new
      else
        fail "Unknown HTTP adapter `#{@options[:http_adapter]}`"
      end
    end

    # Fires a HTTP request against the URI and returns the response body
    #
    # @param [String] uri
    # @return [String]
    def fetch(uri)
      http_adapter.fetch(uri)
    end

    # Parses a String of HTML
    #
    # @param html [String]
    # @return [Nokogiri::HTML::Document]
    def parse_html(html)
      Nokogiri::HTML(html)
    end

    # Registers a callback for the `:before` context
    #
    # @param proc [Proc]
    # @see Scrapespeare::Callbacks#register_callback
    def before(&proc)
      http_adapter.register_callback(:before, &proc)
    end

  end
end
