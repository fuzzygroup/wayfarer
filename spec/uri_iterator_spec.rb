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

          it "constructs the expected URIs" do
            enum = iterator.to_enum
            expect(enum.next.to_s).to eq "http://example.com"
            expect(enum.next.to_s).to eq "http://example.com?page=2"
            expect(enum.next.to_s).to eq "http://example.com?page=3"
          end
        end

        context "with parameter and step given" do
          let(:opts) { { param: "page", step: 2 } }

          it "constructs the expected URIs" do
            enum = iterator.to_enum
            expect(enum.next.to_s).to eq "http://example.com"
            expect(enum.next.to_s).to eq "http://example.com?page=3"
            expect(enum.next.to_s).to eq "http://example.com?page=5"
          end
        end

        context "with parameter and lower bound given" do
          let(:opts) { { param: "page", from: 5 } }

          it "constructs the expected URIs" do
            enum = iterator.to_enum
            expect(enum.next.to_s).to eq "http://example.com"
            expect(enum.next.to_s).to eq "http://example.com?page=5"
            expect(enum.next.to_s).to eq "http://example.com?page=6"
          end
        end
      end
    end

  end
end
