require "spec_helpers"

module Scrapespeare
  describe Crawler do

    let(:crawler) { Crawler.new }

    describe "#scrape" do
      it "yields the scraper" do
        crawler.scrape do
          css :foo, "#foo"
        end

        expect(crawler.scraper.extractables.count).to be 1
      end
    end

    describe "#http_adapter" do
      after { Scrapespeare.config.reset! }

      context "when config.http_adapter is :rest_client" do
        it "sets @http_adapter to a RestClientAdapter" do
          Scrapespeare.config.http_adapter = :rest_client
          expect(crawler.http_adapter).to \
            be_a Scrapespeare::HTTPAdapters::RestClientAdapter
        end
      end

      context "when config.http_adapter is :selenium", live: true do
        before { WebMock.allow_net_connect! }
        after { crawler.http_adapter.release_driver }

        it "sets @http_adapter to a SeleniumAdapter" do
          Scrapespeare.config.http_adapter = :selenium
          expect(crawler.http_adapter).to \
            be_a Scrapespeare::HTTPAdapters::SeleniumAdapter
        end
      end

      context "when config.http_adapter is unrecognized" do
        it "raises a RuntimeError" do
          Scrapespeare.config.http_adapter = :unrecognized
          expect { crawler.http_adapter }.to raise_error(RuntimeError)
        end
      end
    end

    describe "#parse" do
      it "returns a parsed HTML document" do
        html = "<h1>Heading</h1>"
        document = crawler.send(:parse, html)

        expect(document).to be_a Nokogiri::HTML::Document
      end
    end

    describe "#configure" do
      after { Scrapespeare.config.reset! }

      it "yields Scrapespeare.config" do
        crawler.configure do |config|
          config.verbose = true
        end

        expect(Scrapespeare.config.verbose).to be true
      end
    end

    describe "#scraper" do
      it "returns a Scraper" do
        expect(crawler.scraper).to be_a Scraper
      end
    end

  end
end