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

        context "with parameter and upper bound given" do
          let(:opts) { { param: "page", to: 5 } }

          it "yields the expected URIs" do
            uris = iterator.to_enum.map(&:to_s)
            expect(uris).to eq(%w(
              http://example.com
              http://example.com?page=2
              http://example.com?page=3
              http://example.com?page=4
              http://example.com?page=5
            ))
          end
        end

        context "with parameter and step" do
          let(:opts) { { param: "page", step: 2 } }

          it "yields the expected URIs" do
            uris = iterator.to_enum.take(3).map(&:to_s)
            expect(uris).to eq(%w(
              http://example.com
              http://example.com?page=2
              http://example.com?page=4
            ))
          end
        end

        context "with parameter, lower bound, upper bound and step" do
          let(:opts) do
            { param: "page", from: 25, to: 125, step: 25 }
          end

          it "yields the expected URIs" do
            uris = iterator.to_enum.map(&:to_s)
            expect(uris).to eq(%w(
              http://example.com
              http://example.com?page=25
              http://example.com?page=50
              http://example.com?page=75
              http://example.com?page=100
              http://example.com?page=125
            ))
          end
        end
      end
    end

  end
end
