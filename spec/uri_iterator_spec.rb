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
        context "with parameter given" do
          let(:opts) { { param: "page" } }

          it "yields the expected URIs" do
            uris = iterator.to_enum.take(3).map(&:to_s)
            expect(uris).to eq(%w(
              http://example.com
              http://example.com?page=2
              http://example.com?page=3
            ))
          end
        end

        context "with parameter and lower bound given" do
          let(:opts) { { param: "page", from: 5 } }

          it "yields the expected URIs" do
            uris = iterator.to_enum.take(3).map(&:to_s)
            expect(uris).to eq(%w(
              http://example.com
              http://example.com?page=5
              http://example.com?page=6
            ))
          end
        end
      end
    end

  end
end
