require "spec_helpers"

module Scrapespeare
  describe URIIterator do

    describe "#initialize" do
      let(:iterator) { URIIterator.new("http://example.com") }

      it "sets @base_uri" do
        expect(iterator.base_uri).to eq "http://example.com"
      end
    end

  end
end
