# frozen_string_literal: true
require "nokogiri"

module Wayfarer
  module Parsers
    # A wrapper class for parsing HTML/XML.
    # @private
    module XMLParser
      module_function

      # Parses an XML string.
      # @param [String] xml_str the XML string to parse.
      # @return [Nokogiri::XML::Document]
      def parse_xml(xml_str)
        Nokogiri::XML(xml_str)
      end

      # Parses a HTML string.
      # @param [String] html_str the HTML string to parse.
      # @return [Nokogiri::HTML::Document]
      def parse_html(html_str)
        Nokogiri::HTML(html_str)
      end
    end
  end
end
