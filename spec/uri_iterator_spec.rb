require "spec_helpers"

module Scrapespeare
  describe URIIterator do

    describe "#initialize" do
      let(:iterator) { URIIterator.new("http://example.com") }

      it "sets @uri" do
        expect(iterator.uri.to_s).to eq "http://example.com"
      end

      it "sets @rule_set" do
        expect(iterator.rule_set).to eq({})
      end
    end

    describe "#each" do
      let(:uri) { "http://example.com" }

      let(:iterator) { URIIterator.new(uri, { param: "page" }) }

      it "works" do
        enum = iterator.to_enum
        expect(enum.next.to_s).to eq "http://example.com?page=2"
      end
    end

  end
end
