require "spec_helpers"

module Scrapespeare
  describe Crawler do

    let(:crawler) { Crawler.new }

    describe "#scrape" do
      it "yields the scraper" do
        crawler.send(:scrape) do
          1+ 1
        end
      end
    end

  end
end