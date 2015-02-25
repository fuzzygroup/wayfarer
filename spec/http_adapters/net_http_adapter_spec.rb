require "spec_helpers"

module Scrapespeare
  module HTTPAdapters
    describe NetHTTPAdapter do

      let(:adapter) { NetHTTPAdapter.new }

      describe "#fetch" do
        it "returns the status code" do
          uri = URI("http://0.0.0.0:8080/status_code/404")
          status_code, _, _ = adapter.fetch(uri)
          expect(status_code).to be 404
        end

        it "returns the response body" do
          uri = URI("http://0.0.0.0:8080/hello_world")
          _, response_body, _ = adapter.fetch(uri)
          expect(response_body).to match /Hello world!/
        end
      end

    end
  end
end