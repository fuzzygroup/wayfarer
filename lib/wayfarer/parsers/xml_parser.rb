require "nokogiri"

module Wayfarer
  module Parsers
    module XMLParser
      module_function

      def parse_xml(xml_str)
        Nokogiri::XML(xml_str)
      end

      def parse_html(html_str)
        Nokogiri::HTML(html_str)
      end
    end
  end
end
