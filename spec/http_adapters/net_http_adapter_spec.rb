require "spec_helpers"

describe Scrapespeare::HTTPAdapters::NetHTTPAdapter do

  let(:adapter) { HTTPAdapters::NetHTTPAdapter.new }

  describe "#fetch" do
    it "returns a Page" do
      uri = URI("http://0.0.0.0:8080/status_code/404")
      page = adapter.fetch(uri)
      expect(page).to be_a Page
    end
  end

end
