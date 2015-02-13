module Scrapespeare
  class Crawler

    include Configurable

    def initialize
      set Scrapespeare.config
      @paginator = Paginator.new
    end

    def crawl(uri)
      response_body = fetch(uri)
      parsed_document = parse_html(response_body)

      result = @navigator.navigate(response_body)
    end

    # Returns the HTTP adapter determined by `config.http_adapter`
    #
    # @return [Scrapespeare::HTTPAdapters::NetHTTPAdapter, Scrapespeare::HTTPAdapters::SeleniumAdapter]
    # @raise [RuntimeError] if `config.http_adapter` is not `:net_http` or `:selenium`
    def http_adapter
      @http_adapter ||= case config.http_adapter
      when :net_http then Scrapespeare::HTTPAdapters::NetHTTPAdapter.new
      when :selenium then Scrapespeare::HTTPAdapters::SeleniumAdapter.new
      else fail "Unknown HTTP adapter `#{config.http_adapter}`"
      end
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

    # Registers a callback on the HTTP adapter for the `:before` context
    #
    # @param proc [Proc]
    # @see Scrapespeare::Callbacks#register_callback
    def before(&proc)
      http_adapter.register_callback(:before, &proc)
    end

    # Registers a callback on the HTTP adapter for the `:after` context
    #
    # @param proc [Proc]
    # @see Scrapespeare::Callbacks#register_callback
    def after(&proc)
      http_adapter.register_callback(:after, &proc)
    end

  end
end
