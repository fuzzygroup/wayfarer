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
      let(:iterator) { URIIterator.new("http://example.com", rule_set) }

      describe "Query parameter iteration" do
        let(:rule_set) { { param: "page" } }

        it "yields the expected URIs" do
          enum = iterator.to_enum
          expect(enum.next.to_s).to eq "http://example.com"
          expect(enum.next.to_s).to eq "http://example.com?page=2"
        end

        context "with upper bound given" do
          let(:rule_set) { { param: "page", to: 3 } }

          it "yields the expected number of URIs" do
            yielded = []

            iterator.each do |uri|
              yielded << uri.to_s
            end

            expect(yielded).to eq(%w(
              http://example.com
              http://example.com?page=2
              http://example.com?page=3
              http://example.com?page=4
            ))
          end
        end
      end
    end

  end
end
