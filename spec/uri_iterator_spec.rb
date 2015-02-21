require "spec_helpers"

module Scrapespeare
  describe URIIterator do

    describe "#initialize" do
      context "without parameter to iterative over given" do
        it "raises a RuntimeError" do
          expect {
            URIIterator.new("http://example.com")
          }.to raise_error(RuntimeError)
        end
      end
    end

    describe "#each" do
      let(:iterator) { URIIterator.new("http://example.com", opts) }

      context "with parameterized URI given" do
        let(:iterator) do
          URIIterator.new("http://example.com?page=42", { param: "page" })
        end

        it "yields the expected URIs" do
          uris = iterator.to_enum.take(3).map(&:to_s)
          expect(uris).to eq(%w(
            http://example.com?page=42
            http://example.com?page=43
            http://example.com?page=44
          ))
        end
      end

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
        let(:opts) { { param: "page", from: 25, to: 125, step: 25 } }

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
