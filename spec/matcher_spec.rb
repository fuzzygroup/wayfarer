require "spec_helpers"

module Scrapespeare
  describe Matcher do

  describe "#initialize" do
    let(:matcher) { Matcher.new(css: "h1") }

    it "sets @type correctly" do
      expect(matcher.type).to be :css
    end

    it "sets @expression correctly" do
      expect(matcher.expression).to eq "h1"
    end
  end

  describe "#match" do
    let(:doc) do
      Nokogiri::HTML <<-html
        <span id="foo">Foo</span>
        <span id="bar">Bar</span>
      html
    end

    let(:matcher) { Matcher.new(css: "#foo") }

    it "matches the correct nodes" do
      expect(matcher.match(doc).count).to be 1
    end

    context "when @type is unsupported" do
      let(:matcher) { Matcher.new(unsupported: "foobar") }

      it "raises a RuntimeError" do
        expect {
          matcher.match(doc)
        }.to raise_error(RuntimeError)
      end
    end
  end

  end
end
