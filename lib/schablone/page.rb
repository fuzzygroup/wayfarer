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
      puts @headers
      @parsed_document ||= case @headers["content-type"].first
      when /json/ then Parsers::JSONParser.parse(@body)
      else Parsers::XMLParser.parse(@body)
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

    def pismo_document
      @pismo_document ||= build_pismo_document
    end

    def build_pismo_document
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

    def method_missing(method, *args, &proc)
      pismo_document.send(method, *args, &proc)
    end

    def respond_to_missing?(method, private = false)
      pismo_document.respond_to?(method) || super
    end
  end
end
