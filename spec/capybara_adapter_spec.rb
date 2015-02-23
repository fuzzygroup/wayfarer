require "spec_helpers"

module Scrapespeare
  describe HTTPClient, live: true do

    let(:client) { HTTPClient.new }

    describe "#initialize" do
      after { client.free }

      it "initializes a new Session" do
        expect(client.session).to be_a Capybara::Session
      end

      it "initializes a Session with the expected Driver" do
        Scrapespeare.config.capybara_driver = :selenium

        client = HTTPClient.new
        expect(client.session.mode).to be :selenium

        client.free
        Scrapespeare.config.reset!
      end
    end

    describe "#free" do
      context "with active Session" do
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

    describe "#recover" do
      it "frees the current Session and initializes a new one" do
        cached_session = client.session
        client.send(:recover)
        expect(client.session).not_to be cached_session
      end
    end

    describe "#fetch" do
      after { client.free }

      let(:uri) { "http://0.0.0.0:8080/hello_world" }

      it "returns the status code" do
        status_code, _, _ = client.fetch(uri)
        expect(status_code).to be 200
      end

      it "returns the response headers" do
        _, response_headers, _ = client.fetch(uri)
        expect(response_headers["Hello"]).to eq "World"
      end

      it "returns the response body" do
        _, _, response_body = client.fetch(uri)
        expect(response_body).to match /Hello world!/
      end

      it "sends HTTP headers retrieved from config.headers" do
        Scrapespeare.config.headers = { "User-Agent" => "Foobar" }

        _, _, response_body = client.fetch("http://0.0.0.0:8080/user_agent")
        expect(response_body).to match /Hello there, Foobar!/

        Scrapespeare.config.reset!
      end

      context "when encountering a redirect loop" do
        let(:uri) { "http://0.0.0.0:8080/redirect_loop" }

        it "returns a 500 status code" do
          status_code, _, _ = client.fetch(uri)
          expect(status_code).to be 500
        end

        it "returns an empty Hash as response headers" do
          _, response_headers, _ = client.fetch(uri)
          expect(response_headers).to eq({})
        end

        it "returns an empty String as the response body" do
          _, _, response_body = client.fetch(uri)
          expect(response_body).to eq ""
        end
      end
    end

  end
end
