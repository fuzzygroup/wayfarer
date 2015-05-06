require "uri"
require "nokogiri"
require "pismo"

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
      content_type = @headers["content-type"].first

      @parsed_document ||= case content_type
      when /json/
        Parsers::JSONParser.parse(@body).extend(
          Hashie::Extensions::MethodReader
        )
      else
        Parsers::XMLParser.parse(@body)
      end
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

    def current?(uri)
      @current_uris.include?(uri)
    end

    # Returns a {Pismo::Document}
    #
    # @return [Pismo::Document]
    def pismo_document
      @pismo_document ||= instantiate_pismo_document
    end

    # Builds a {Pismo::Document}, bypassing initialization
    #
    # @return [Pismo::Document]
    def instantiate_pismo_document
      doc = Pismo::Document.allocate
      doc.instance_variable_set(:@options, {})
      doc.instance_variable_set(:@url, self.uri)
      doc.instance_variable_set(:@html, self.body)
      doc.instance_variable_set(:@doc, self.parsed_document)
      doc
    end

    def expand_uri(path)
      URI.join(@uri, path)
    end

    # untested
    def method_missing(method, *argv, &proc)
      pismo_document.send(method, *argv, &proc)
    end

    #untested
    def respond_to_missing?(method, private = false)
      pismo_document.respond_to?(method) || super
    end
  end
end
