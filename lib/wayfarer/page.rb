# frozen_string_literal: true
require "ostruct"
require "forwardable"
require "mime/types"
require "mime-types"
require "pismo"

module Wayfarer
  # A representation of fetched pages
  class Page
    extend Forwardable

    include Finders

    # @!attribute [r] uri
    # @return [URI] the URI of the page.
    attr_reader :uri

    # @!attribute [r] status_code
    # @return [Fixnum] the response status code.
    attr_reader :status_code

    # @!attribute [r] body
    # @return [String] the response body.
    attr_reader :body

    # @!attribute [r] headers
    # @return [Hash] the response headers.
    attr_reader :headers

    def initialize(attrs = {})
      @uri         = attrs[:uri]
      @status_code = attrs[:status_code]
      @body        = attrs[:body]
      @headers     = attrs[:headers]
    end

    # Returns a parsed representation of the fetched document depending on the
    # Content-Type field.
    # @return [OpenStruct] if the Content-Type field's sub-type is "json".
    # @return [Nokogiri::XML::Document] if the Content-Type field's sub-type is "xml".
    # @return [Nokogiri::HTML::Document] otherwise.
    def doc
      return @doc if @doc

      # If no Content-Type field is present, assume HTML/XML
      # TODO: Test
      unless @headers["content-type"]
        return @doc = Parsers::XMLParser.parse_html(@body)
      end

      content_type = @headers["content-type"].first
      sub_type = MIME::Types[content_type].first.sub_type

      # TODO: Tests
      @doc = case sub_type
             when "json"
               Parsers::JSONParser.parse(@body)
             when "xml"
               Parsers::XMLParser.parse_xml(@body)
             else
               Parsers::XMLParser.parse_html(@body)
             end
    end

    # `#images` is provided by the Helpers module
    # `#body` is an attribute reader defined above
    delegate (Pismo::Document::ATTRIBUTE_METHODS - [:images, :body]) => :pismo

    private

    # Returns a Pismo document.
    # @note Only succeeds when {#doc} returns a `Nokogiri::HTML::Document`.
    # @return [Pismo::Document]
    def pismo
      @pismo_doc ||= instantiate_pismo_document
    end

    def instantiate_pismo_document
      doc = Pismo::Document.allocate
      doc.instance_variable_set(:@options, {})
      doc.instance_variable_set(:@url, uri)
      doc.instance_variable_set(:@html, body)
      doc.instance_variable_set(:@doc, self.doc)
      doc
    end
  end
end
