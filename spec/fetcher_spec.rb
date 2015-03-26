require "spec_helpers"

describe Schablone::Fetcher do
  let(:fetcher) { subject.class.new }

  describe "#fetch" do
    it "returns a Page" do
      uri = URI("http://0.0.0.0:9876/hello_world")
      page = fetcher.fetch(uri)
      expect(page).to be_a Page
    end

    it "sets the correct URI" do
      uri = URI("http://0.0.0.0:9876/status_code/404")
      page = fetcher.fetch(uri)
      expect(page.uri.to_s).to eq "http://0.0.0.0:9876/status_code/404"
    end

    it "retrieves the correct HTTP status code" do
      uri = URI("http://0.0.0.0:9876/status_code/404")
      page = fetcher.fetch(uri)
      expect(page.status_code).to be 404
    end

    it "retrieves the correct response body" do
      uri = URI("http://0.0.0.0:9876/hello_world")
      page = fetcher.fetch(uri)
      expect(page.body).to eq "Hello world!"
    end

    it "retrieves the correct response headers" do
      uri = URI("http://0.0.0.0:9876/hello_world")
      page = fetcher.fetch(uri)
      expect(page.headers["hello"]).to eq ["world"]
    end

    context "when response is a redirect" do
      it "follows the redirect" do
        uri = URI("http://0.0.0.0:9876/redirect?times=3")
        page = fetcher.fetch(uri)

        expect(page.uri.to_s).to eq "http://0.0.0.0:9876/redirect?times=0"
      end

      context "when maximum number of redirects reached" do
        before { Schablone.config.max_http_redirects = 5 }
        after  { Schablone.config.reset! }

        it "raises a RuntimeError" do
          expect do
            uri = URI("http://0.0.0.0:9876/redirect?times=6")
            page = fetcher.fetch(uri)
          end.to raise_error(RuntimeError)
        end
      end
    end
  end
end
