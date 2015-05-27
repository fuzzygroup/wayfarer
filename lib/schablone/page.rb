require "uri"
require "ostruct"
require "mime/types"
require "nokogiri"

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
      return @parsed_document if @parsed_document

      content_type = @headers["content-type"].first
      sub_type = MIME::Types[content_type].first.sub_type

      @parsed_document = case sub_type
      when "json"
        OpenStruct.new(Parsers::JSONParser.parse(@body))
      when "xml"
        Parsers::XMLParser.parse_xml(@body)
      else
        Parsers::XMLParser.parse_html(@body)
      end
    end

    def pismo
      @pismo_document ||= instantiate_pismo_document if defined?(Pismo)
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
  end
end
