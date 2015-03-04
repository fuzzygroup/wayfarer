require "spec_helpers"

describe Scrapespeare::Fetcher do

  let(:fetcher) { subject.class.new }

  describe "#fetch" do
    it "returns a Page" do
      uri = URI("http://0.0.0.0:8080/hello_world")
      page = fetcher.fetch(uri)
      expect(page).to be_a Page
    end

    it "retrieves the correct HTTP status code" do
      uri = URI("http://0.0.0.0:8080/status_code/404")
      page = fetcher.fetch(uri)
      expect(page.status_code).to be 404
    end

    it "retrieves the correct response body" do
      uri = URI("http://0.0.0.0:8080/hello_world")
      page = fetcher.fetch(uri)
      expect(page.body).to eq "Hello world!"
    end

    it "retrieves the correct response headers" do
      uri = URI("http://0.0.0.0:8080/hello_world")
      page = fetcher.fetch(uri)
      expect(page.headers["hello"]).to eq ["world"]
    end

    context "when response is a redirect" do
      it "follows the redirect" do
        uri = URI("http://0.0.0.0:8080/redirect?times=3")
        page = fetcher.fetch(uri)

        expect(page.status_code).to be 200
        expect(page.body).to eq "You arrived!"
      end

      context "when maximum number of redirects reached" do
        before { Scrapespeare.config.max_http_redirects = 5 }
        after  { Scrapespeare.config.reset! }

        it "raises a RuntimeError" do
          expect {
            uri = URI("http://0.0.0.0:8080/redirect?times=6")
            page = fetcher.fetch(uri)
          }.to raise_error(RuntimeError)
        end
      end
    end

  end

end
