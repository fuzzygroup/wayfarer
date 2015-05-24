require "uri"
require "nokogiri"
require "pismo"
require "mime/types"

module Schablone
  class Page
    attr_reader :uri
    attr_reader :status_code
    attr_reader :body
    attr_reader :headers

    def initialize(env = {})
      @uri         = env[:uri]
      @status_code = env[:status_code]
      @body        = env[:body]
      @headers     = env[:headers]
    end

    def parsed_document
      content_type = @headers["content-type"].first
      sub_type = MIME::Types[content_type].first.sub_type

      @parsed_document ||= case sub_type
      when "json"
        Parsers::JSONParser.parse(@body).extend(
          Hashie::Extensions::MethodReader
        )
      when "xml"
        Parsers::XMLParser.parse_xml(@body)
      else
        Parsers::XMLParser.parse_html(@body)
      end
    end

    def pismo_document
      @pismo_document ||= instantiate_pismo_document
    end

    def links(matcher_hash = { css: "a" })
      nodes = Extraction::Matcher.new(matcher_hash).match(parsed_document)

      uris = nodes.map do |node|
        begin
          expand_uri(node.attr("href"))
        rescue ArgumentError, URI::InvalidURIError
          nil
        end
      end

      uris.uniq.find_all { |uri| uri.is_a? URI }
    end

    private

    def instantiate_pismo_document
      doc = Pismo::Document.allocate
      doc.instance_variable_set(:@options, {})
      doc.instance_variable_set(:@url, uri)
      doc.instance_variable_set(:@html, body)
      doc.instance_variable_set(:@doc, parsed_document)
      doc
    end

    def expand_uri(path)
      URI.join(@uri, path)
    end

    def method_missing(*argv, &proc)
      pismo_document.send(*argv, &proc)
    end

    def respond_to_missing?(method, *)
      pismo_document.respond_to?(method) || super
    end
  end
end
