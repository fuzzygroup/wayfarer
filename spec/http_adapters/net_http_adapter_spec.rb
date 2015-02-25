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
          expect(response_body).to eq "Hello world!"
        end

        it "returns the headers" do
          uri = URI("http://0.0.0.0:8080/hello_world")
          _, _, headers = adapter.fetch(uri)
          expect(headers["hello"]).to eq ["world"]
        end

        describe "Redirects" do
          it "follows redirects" do
            uri = URI("http://0.0.0.0:8080/redirect?times=1")
            _, response_body, _ = adapter.fetch(uri)
            expect(response_body).to match /You arrived!/
          end

          it "adheres to config.max_http_redirects" do
            Scrapespeare.config.max_http_redirects = 5

            expect {
              uri = URI("http://0.0.0.0:8080/redirect?times=6")
              res = adapter.fetch(uri)
            }.to raise_error(RuntimeError)

            Scrapespeare.config.reset!
          end
        end
      end

    end
  end
end