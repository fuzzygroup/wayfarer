require "spec_helpers"

describe Schablone::Extraction::Matcher do

  let(:doc) do
    Nokogiri::HTML <<-html
      <span id="foo">Foo</span>
      <span id="bar">Bar</span>
    html
  end

  subject(:matcher) { Matcher.new(matcher_hash) }

  describe "#initialize" do
    let(:matcher_hash) { { css: "#foo" } }

    it "sets `@type`" do
      expect(matcher.type).to be :css
    end

    it "sets `@type`" do
      expect(matcher.expression).to eq "#foo"
    end
  end

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

    context "with unknown selector type" do
      let(:matcher_hash) { { unknown: nil } }

      it "raises a RuntimeError" do
        expect { matcher.match(doc) }.to raise_error(RuntimeError)
      end
    end
  end

end
