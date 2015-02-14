require "spec_helpers"

module Scrapespeare
  module HTTPAdapters
    describe FaradayAdapter do

      let(:adapter) { FaradayAdapter.new }

      describe "#fetch" do
        before do
          stub_request(:get, "http://example.com").to_return(body: "Succeeded")
        end

        it "returns the response body" do
          expect(adapter.fetch("http://example.com")).to eq "Succeeded"
        end
      end

    end
  end
end
