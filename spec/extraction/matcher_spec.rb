require "spec_helpers"

describe Schablone::Extraction::Matcher do
  let(:doc) do
    Nokogiri::HTML <<-html
      <span id="foo">Foo</span>
      <span id="bar">Bar</span>
    html
  end

  subject(:matcher) { Matcher.new(matcher_hash) }

  describe "#match" do
    context "with CSS selector" do
      let(:matcher_hash) { { css: "#foo" } }

      it "returns the matched NodeSet" do
        matched_nodes = matcher.match(doc)
        expect(matched_nodes.count).to be 1
      end
    end

    context "with XPath expression" do
      let(:matcher_hash) { { xpath: "//*[@id='foo']" } }

      it "returns the matched NodeSet" do
        matched_nodes = matcher.match(doc)
        expect(matched_nodes.count).to be 1
      end
    end
  end
end
