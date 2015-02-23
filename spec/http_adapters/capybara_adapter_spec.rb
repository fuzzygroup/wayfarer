require "spec_helpers"

module Scrapespeare
  describe HTTPClient, live: true do

    let(:adapter) { HTTPClient.new }

    describe "#initialize" do
      after { adapter.free }

      it "initializes a new Session" do
        expect(adapter.session).to be_a Capybara::Session
      end
    end

    describe "#free" do
      it "quits its Session" do
        adapter.free
        expect(adapter.session).to be nil
      end
    end

    describe "#fetch" do
      after { adapter.free }

      it "returns the status code" do
        res = adapter.fetch("http://0.0.0.0:8080/hello_world.html")
        status_code, _, _ = res
        expect(status_code).to be 200
      end

      it "returns the response headers" do
        res = adapter.fetch("http://0.0.0.0:8080/hello_world.html")
        _, response_headers, _ = res
        expect(response_headers).to be_a Hash
      end

      it "returns the response body" do
        res = adapter.fetch("http://0.0.0.0:8080/hello_world.html")
        _, _, response_body = res
        expect(response_body).to match /Hello world!/
      end
    end

  end
end
