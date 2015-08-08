require "spec_helpers"

describe Wayfarer::HTTPAdapters::NetHTTPAdapter do
  subject(:adapter) { Wayfarer::HTTPAdapters::NetHTTPAdapter.instance }

  describe "#fetch" do
    it "returns a Page" do
      uri = test_app("/hello_world")
      page = adapter.fetch(uri)
      expect(page).to be_a Page
    end

    it "sets the correct URI" do
      uri = test_app("/status_code/404")
      page = adapter.fetch(uri)
      expect(page.uri).to eq test_app("/status_code/404")
    end

    it "retrieves the correct HTTP status code" do
      uri = URI("http://0.0.0.0:9876/status_code/404")
      page = adapter.fetch(uri)
      expect(page.status_code).to be 404
    end

    it "retrieves the correct response body" do
      uri = URI("http://0.0.0.0:9876/hello_world")
      page = adapter.fetch(uri)
      expect(page.body).to eq "Hello world!"
    end

    it "retrieves the correct response headers" do
      uri = URI("http://0.0.0.0:9876/hello_world")
      page = adapter.fetch(uri)
      expect(page.headers["hello"]).to eq ["world"]
    end

    context "with malformed URI" do
      it "raises a MalformedURI" do
        expect do
          uri = URI("hptt://bro.ken")
          page = adapter.fetch(uri)
        end.to raise_error(
          Wayfarer::HTTPAdapters::NetHTTPAdapter::MalformedURI
        )
      end
    end

    context "when response is a redirect" do
      it "follows the redirect" do
        uri = URI("http://0.0.0.0:9876/redirect?times=3")
        page = adapter.fetch(uri)

        expect(page.uri.to_s).to eq "http://0.0.0.0:9876/redirect?times=0"
      end

      context "when maximum number of redirects reached" do
        before { Wayfarer.config.max_http_redirects = 5 }
        after  { Wayfarer.config.reset! }

        it "raises a MaximumRedirectCountReached" do
          expect do
            uri = URI("http://0.0.0.0:9876/redirect?times=6")
            page = adapter.fetch(uri)
          end.to raise_error(
            Wayfarer::HTTPAdapters::NetHTTPAdapter::MaximumRedirectCountReached
          )
        end
      end

      context "when redirection URI is malformed" do
        it "raises a MalformedRedirectURI" do
          expect do
            uri = test_app("/malformed_redirect")
            page = adapter.fetch(uri)
          end.to raise_error(
            Wayfarer::HTTPAdapters::NetHTTPAdapter::MalformedRedirectURI
          )
        end
      end
    end
  end
end
