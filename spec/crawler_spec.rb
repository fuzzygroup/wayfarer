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

  describe "#define_scraper" do
    it "yields its Scraper" do
      crawler.define_scraper do
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

  describe "#set_evaluator_for" do
    let(:extractor) { Extractor.new(:foo, css: "#foo") }

    before do
      crawler.scraper.instance_variable_set(:@extractables, [extractor])
    end

    context "with evaluator object given" do
      let(:evaluator) { Object.new }

      it "passes the evaluator to the corresponding Extractable(s)" do
        crawler.set_evaluator_for(:foo, evaluator)
        expect(extractor.evaluator).to be evaluator
      end
    end

    context "with Proc given" do
      it "passes the evaluator to the corresponding Extractable(s)" do
        crawler.set_evaluator_for(:foo) { |matched_nodes, *target_attrs| }
        expect(extractor.evaluator).to be_a Proc
      end
    end

    context "with neither evaluator object nor Proc given" do
      it "raises an ArgumentError" do
        expect {
          crawler.set_evaluator_for(:foo)
        }.to raise_error(ArgumentError)
      end
    end
  end

end