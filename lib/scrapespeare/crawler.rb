module Scrapespeare
  class Crawler

    include Configurable

    def initialize
      set(:http_adapter, :net_http)
    end

    # Returns and/or sets `@http_adapter` TODO
    #
    # @return [Scrapespeare::HTTPAdapters::NetHTTPAdapter, Scrapespeare::HTTPAdapters::SeleniumAdapter]
    # @raise [RuntimeError] if `@options[:http_adapter]` is not `:net_http` or `:selenium`
    def http_adapter
      return @http_adapter if @http_adapter

      case options[:http_adapter]
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
