require "uri"
require "ostruct"
require "mime/types"
require "nokogiri"

module Wayfarer
  class Page
    attr_reader :uri
    attr_reader :status_code
    attr_reader :body
    attr_reader :headers

    def initialize(opts = {})
      @uri         = opts[:uri]
      @status_code = opts[:status_code]
      @body        = opts[:body]
      @headers     = opts[:headers]
    end

    def doc
      return @doc if @doc

      # If no Content-Type field is present, assume HTML
      # TODO Test case
      unless @headers["content-type"]
        return Parsers::XMLParser.parse_html(@body)
      end

      # TODO Maybe get rid of the mime gem?
      content_type = @headers["content-type"].first
      sub_type = MIME::Types[content_type].first.sub_type

      @doc = case sub_type
             when "json"
               OpenStruct.new(Parsers::JSONParser.parse(@body))
             when "xml"
               Parsers::XMLParser.parse_xml(@body)
             else
               Parsers::XMLParser.parse_html(@body)
             end
    end

    def pismo
      @pismo_doc ||= instantiate_pismo_document
    end

    def links(*argv)
      links = doc.search(*argv).map do |node|
        URI.join(@uri, node.attr("href")) rescue nil
      end

      links.uniq.find_all { |link| link.is_a? URI }
    end

    def links!(*argv)
      links(*argv).first
    end

    private

    def instantiate_pismo_document
      doc = Pismo::Document.allocate
      doc.instance_variable_set(:@options, {})
      doc.instance_variable_set(:@url, uri)
      doc.instance_variable_set(:@html, body)
      doc.instance_variable_set(:@doc, doc)
      doc
    end
  end
end