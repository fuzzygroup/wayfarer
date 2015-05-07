require "spec_helpers"

describe Schablone::Parsers::XMLParser do
  subject(:parser) { Parsers::XMLParser }

  describe ".parse_html" do
    it "returns a Nokogiri::HTML::Document" do
      html_str = "<span>Foobar</span>"
      doc = parser.parse_html(html_str)

      expect(doc).to be_a Nokogiri::HTML::Document
    end
  end

  describe ".parse_xml" do
    it "returns a Nokogiri::XML::Document" do
      xml_str = "<barqux>Foobar</barqux>"
      doc = parser.parse_xml(xml_str)

      expect(doc).to be_a Nokogiri::XML::Document
    end
  end
end
