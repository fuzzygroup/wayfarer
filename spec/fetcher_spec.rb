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
  end

end
