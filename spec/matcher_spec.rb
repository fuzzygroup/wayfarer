require "spec_helpers"

module Scrapespeare
  describe Matcher do

  describe "#initialize" do
    let(:matcher) { Matcher.new(css: "h1") }

    it "sets @type" do
      expect(matcher.type).to be :css
    end

    it "sets @expression" do
      expect(matcher.expression).to eq "h1"
    end
  end

  describe "#match" do
    let(:document_or_nodes) { spy("document_or_nodes") }

    context "when @type is :css" do
      let(:matcher) { Matcher.new(css: "h1") }

      it "calls #css on document_or_nodes" do
        matcher.match(document_or_nodes)
        expect(document_or_nodes).to have_received(:css)
      end
    end

    context "when @type is unsupported" do
      let(:matcher) { Matcher.new(unsupported: "foobar") }

      it "raises a RuntimeError" do
        expect {
          matcher.match(document_or_nodes)
        }.to raise_error(RuntimeError)
      end
    end
  end

  end
end
