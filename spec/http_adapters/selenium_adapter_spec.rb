require "spec_helpers"

# TODO Use shared examples for HTTP adapters
describe Wayfarer::HTTPAdapters::SeleniumAdapter, selenium: true do
  subject(:adapter) { Wayfarer::HTTPAdapters::SeleniumAdapter.new }
  after { adapter.free }

  describe "#fetch" do
    it "returns a Page" do
      uri = URI("http://0.0.0.0:9876/hello_world")
      page = adapter.fetch(uri)
      expect(page).to be_a Page
    end

    it "sets the correct URI" do
      uri = URI("http://0.0.0.0:9876/status_code/404")
      page = adapter.fetch(uri)
      expect(page.uri.to_s).to eq "http://0.0.0.0:9876/status_code/404"
    end

    it "retrieves the correct HTTP status code" do
      uri = URI("http://0.0.0.0:9876/status_code/404")
      page = adapter.fetch(uri)
      expect(page.status_code).to be 404
    end

    it "retrieves the correct response body" do
      uri = URI("http://0.0.0.0:9876/hello_world")
      page = adapter.fetch(uri)
      expect(page.body).to match /Hello world!/
    end

    it "retrieves the correct response headers" do
      uri = test_app("/hello_world")
      page = adapter.fetch(uri)
      expect(page.headers["hello"]).to eq ["world"]
    end

    context "when response is a redirect" do
      it "follows the redirect" do
        uri = test_app("/redirect?times=3")
        page = adapter.fetch(uri)
        expect(page.uri.to_s).to eq test_app("/redirect?times=0").to_s
      end

      context "when encountering a redirect loop" do
        it "returns `nil` as HTTP status code" do
          pending; fail
        end
      end
    end
  end
end
