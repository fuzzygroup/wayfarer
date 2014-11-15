require "spec_helpers"

module Scrapespeare
  module HTTPAdapters
    describe SeleniumAdapter do

      let(:adapter) { SeleniumAdapter }

      describe "#fetch" do
        before do
          WebMock.disable_net_connect!(allow: "127.0.0.1")
        end

        it "returns the HTTP response body", live: true do
          response_body = adapter.fetch("http://example.com")
          expect(response_body).to match /Example Domain/
        end
      end

    end
  end
end
