require "spec_helpers"

module Scrapespeare
  module HTTPAdapters
    describe NetHTTPAdapter do

      let(:adapter) { NetHTTPAdapter.new }

      it "returns the status code" do
        uri = URI("http://0.0.0.0:8080/status_code/404")
        status_code, _, _ = adapter.fetch(uri)
        expect(status_code).to be 404
      end

    end
  end
end