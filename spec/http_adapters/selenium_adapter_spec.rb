require "spec_helpers"

describe Scrapespeare::HTTPAdapters::SeleniumAdapter do

  let(:adapter) { Scrapespeare::HTTPAdapters::SeleniumAdapter }

  describe "#fetch" do
    before do
      WebMock.disable_net_connect!(allow: "127.0.0.1")
    end

    it "returns the HTTP response body", live: true do
      page_source = adapter.fetch("http://example.com")
      expect(page_source).to match /Example Domain/
    end
  end

end
