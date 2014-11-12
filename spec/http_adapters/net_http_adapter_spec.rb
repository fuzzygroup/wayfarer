require "spec_helpers"

describe Scrapespeare::HTTPAdapters::NetHTTPAdapter do

  let(:adapter) { Scrapespeare::HTTPAdapters::NetHTTPAdapter }

  describe "#fetch" do
    before do
      stub_request(:get, "http://example.com").to_return(
        body: "Succeeded"
      )
    end

    it "returns the HTTP response body" do
      page_source = adapter.fetch("http://example.com")
      expect(page_source).to eq "Succeeded"
    end
  end

end
