require "spec_helpers"

describe Scrapespeare::Parser do

  let(:parser) { subject }

  describe ".parse" do
    it "returns a parsed HTML document" do
      html_str = "<span>Foobar</span>"
      doc = parser.parse(html_str)

      expect(doc).to be_a Nokogiri::HTML::Document
    end
  end

end
