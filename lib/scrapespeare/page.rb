require "uri"

module Scrapespeare
  class Page

    attr_reader :uri
    attr_reader :status_code
    attr_reader :body
    attr_reader :headers

    def initialize(*env)
      @uri, @status_code, @body, @headers = env
    end

    def parsed_document
      @parsed_document ||= Nokogiri::HTML(@body)
    end

    def links
      uris = parsed_document.css("a").map do |node|
        expand_uri(node.attr("href"))
      end

      Set.new(uris)
    end

    def internal_links
      links.find_all { |uri| is_internal_link?(uri) }
    end

    private
    def expand_uri(path)
      URI.join(@uri, path)
    end

    def is_internal_link?(uri)
      uri.host == @uri.host
    end

  end
end
