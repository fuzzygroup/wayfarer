require "spec_helpers"

module Scrapespeare
  module HTTPAdapters
    describe NetHTTPAdapter do

      let(:adapter) { NetHTTPAdapter.new }

      describe "#fetch" do
        context "response code is 200" do
          before do
            stub_request(:get, "http://example.com").to_return(
              body: "Succeeded"
            )
          end

          it "returns the HTTP response body" do
            response_body = adapter.fetch("http://example.com")
            expect(response_body).to eq "Succeeded"
          end
        end

        context "response code is 301" do
          before do
            stub_request(:get, "http://example.com").to_return(
              status: [301, "Moved Permanently"],
              headers: { location: "http://new.example.com" }
            )

            stub_request(:get, "http://new.example.com").to_return(
              body: "Followed a redirect"
            )
          end

          it "follows the redirect" do
            response_body = adapter.fetch("http://example.com")
            expect(response_body).to eq "Followed a redirect"
          end
        end
      end

    end
  end
end
