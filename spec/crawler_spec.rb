require "spec_helpers"

describe Scrapespeare::Crawler do

  let(:crawler) { subject.class.new }

  describe "#crawl" do
    context "with URI given" do
      it "sets @base_uri" do
        crawler.crawl("http://example.com")
        expect(crawler.base_uri.to_s).to eq "http://example.com"
      end
    end

    context "with URI template and parameters given" do
      before do
        crawler.uri_template = "http://example.com/foo/%{alpha}/bar/%{beta}"
      end

      it "constructs and sets the correct URI" do
        crawler.crawl({ alpha: 4, beta: 2 })
        expect(crawler.base_uri.to_s).to eq "http://example.com/foo/4/bar/2"
      end

      it "escapes URI template parameters" do
        crawler.crawl({
          alpha: "I ain't even alphanumerical",
          beta: 42
        })
        expect(crawler.base_uri.to_s).to eq \
          "http://example.com/foo/I%20ain't%20even%20alphanumerical/bar/42"
      end
    end

    context "with URI template and insufficient parameters given" do
      before do
        crawler.uri_template = "http://example.com/%{foo}"
      end

      it "throws an ArgumentError" do
        expect {
          crawler.crawl({ bar: 5 })
        }.to raise_error(ArgumentError)
      end
    end

    context "without URI template and parameters given" do
      it "throws a RuntimeError" do
        expect {
          crawler.crawl({ alpha: 4, beta: 2 })
        }.to raise_error(RuntimeError )
      end
    end
  end

  describe "#scrape" do
    it "stores a Scraper" do
      crawler.scrape(:foo)
      expect(crawler.scrapers).to have_key :foo
    end

    it "yields the added Scraper" do
      crawler.scrape(:foo) { css(:bar, "#bar") }
      added_scraper = crawler.scrapers[:foo]
      expect(added_scraper.extractables.count).to be 1
    end
  end

end