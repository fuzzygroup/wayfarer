require "uri"
require "nokogiri"

module Schablone
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

    def links(matcher_hash = { css: "a" })
      nodes = Extraction::Matcher.new(matcher_hash).match(parsed_document)

      uris = nodes.map do |node|
        begin
          expand_uri(node.attr("href"))
        rescue ArgumentError, URI::InvalidURIError
          # `URI::join` raises an exception if its arguments can not be used to
          # construct a valid URI
          nil
        end
      end

      # Filter duplicates and `nil`s resulting from exceptions raised by
      # `URI::join`
      uris.uniq.find_all { |uri| uri.is_a? URI }
    end

    private

    def expand_uri(path)
      URI.join(@uri, path)
    end
  end
end
