require "spec_helpers"

module Scrapespeare
  describe Crawler do

    let(:crawler) { Crawler.new }

    describe "#crawl" do
      context "with URI given" do
        it "sets @uri" do
          crawler.crawl("http://example.com")
          expect(crawler.uri.to_s).to eq "http://example.com"
        end
      end

      context "with URI template and parameters given" do
        before do
          crawler.uri_template = "http://example.com/foo/%{alpha}/bar/%{beta}"
        end

        it "constructs and sets the correct URI" do
          crawler.crawl({ alpha: 4, beta: 2 })
          expect(crawler.uri.to_s).to eq "http://example.com/foo/4/bar/2"
        end

        it "escapes URI template parameters" do
          crawler.crawl({
            alpha: "I ain't even alphanumerical",
            beta: 42
          })
          expect(crawler.uri.to_s).to eq \
            "http://example.com/foo/I%20ain't%20even%20alphanumerical/bar/42"
        end
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