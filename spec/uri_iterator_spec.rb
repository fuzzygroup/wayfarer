require "spec_helpers"

module Scrapespeare
  describe URIIterator do

    describe "#initialize" do
      let(:iterator) { URIIterator.new("http://example.com") }

      it "sets @uri" do
        expect(iterator.uri.to_s).to eq "http://example.com"
      end

      it "sets @opts" do
        expect(iterator.opts).to eq({})
      end
    end

    describe "#each" do
      let(:iterator) { URIIterator.new("http://example.com", opts) }

      describe "Query parameter iteration" do
        context "with only parameter given" do
          let(:opts) { { param: "page" } }

          it "constructs the expected URIs" do
            enum = iterator.to_enum
            expect(enum.next.to_s).to eq "http://example.com"
            expect(enum.next.to_s).to eq "http://example.com?page=2"
            expect(enum.next.to_s).to eq "http://example.com?page=3"
          end
        end
      end
    end

  end
end
