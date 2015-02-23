require "spec_helpers"

module Scrapespeare
  describe HTTPClient, live: true do

    let(:client) { HTTPClient.new }

    describe "#initialize" do
      after { client.free }

      it "initializes a new Session" do
        expect(client.session).to be_a Capybara::Session
      end

      it "initializes its Driver according to config.capybara_driver" do
        Scrapespeare.config.capybara_driver = :selenium

        client = HTTPClient.new
        expect(client.session.mode).to be :selenium

        client.free
        Scrapespeare.config.reset!
      end
    end

    describe "#free" do
      context "with active session" do
        it "quits its Session" do
          client.free
          expect(client.session).to be nil
        end

        it "returns true" do
          expect(client.free).to be true
        end
      end

      context "with freed Session" do
        before { client.free }

        it "returns false" do
          expect(client.free).to be false
        end
      end
    end

    describe "#fetch" do
      after { client.free }

      it "returns the status code" do
        res = client.fetch("http://0.0.0.0:8080/hello_world")
        status_code, _, _ = res
        expect(status_code).to be 200
      end

      it "returns the response headers" do
        res = client.fetch("http://0.0.0.0:8080/hello_world")
        _, response_headers, _ = res
        expect(response_headers["Hello"]).to eq "World"
      end

      it "returns the response body" do
        res = client.fetch("http://0.0.0.0:8080/hello_world")
        _, _, response_body = res
        expect(response_body).to match /Hello world!/
      end
    end

  end
end
