require "spec_helpers"

module Scrapespeare
  describe URIIterator do

    describe "#initialize" do
      let(:iterator) { URIIterator.new("http://example.com") }

      it "sets @base_uri" do
        expect(iterator.base_uri).to eq "http://example.com"
      end

      it "sets @rule_set" do
        expect(iterator.rule_set).to eq({})
      end
    end

  end
end
