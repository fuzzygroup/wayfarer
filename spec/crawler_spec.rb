require "spec_helpers"

module Scrapespeare
  describe Crawler do

    let(:crawler) { Crawler.new }

    describe "#crawl" do
      it "sets @uri" do
        crawler.crawl("http://example.com")
        expect(crawler.uri).to eq "http://example.com"
      end
    end

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
        it "returns a RestClientAdapter" do
          Scrapespeare.config.http_adapter = :rest_client
          expect(crawler.http_adapter).to \
            be_a Scrapespeare::HTTPAdapters::RestClientAdapter
        end
      end

      context "when config.http_adapter is :selenium", live: true do
        before { WebMock.allow_net_connect! }
        after { crawler.http_adapter.release_driver }

        it "returns a SeleniumAdapter" do
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

    describe "#evaluate" do
      let(:extractor) { Extractor.new(:foo, css: "#foo") }

      before do
        crawler.scraper.instance_variable_set(:@extractables, [extractor])
      end

      context "with evaluator object given" do
        let(:evaluator) { Object.new }

        it "passes the evaluator to the corresponding Extractable(s)" do
          crawler.evaluate :foo, evaluator
          expect(extractor.evaluator).to be evaluator
        end
      end

      context "with block given" do
        it "passes the evaluator to the corresponding Extractable(s)" do
          crawler.evaluate(:foo) { |matched_nodes, *target_attrs| }
          expect(extractor.evaluator).to be_a Proc
        end
      end
    end

  end
end