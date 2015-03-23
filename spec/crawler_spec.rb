require "spec_helpers"

describe Scrapespeare::Crawler do

  let(:crawler) { subject.class.new }

  describe "#setup_scraper, #scraper" do
    context "without Proc given" do
      it "returns the Scraper" do
        expect(crawler.scraper).to be_a Scraper
      end
    end

    context "with Proc of arity 0 given" do
      it "evaluates the given Proc in its Scraper's instance context" do
        this = nil
        crawler.setup_scraper { this = self }
        expect(this).to be crawler.scraper
      end
    end

    context "with Proc of arity 1 given" do
      it "yields the Scraper" do
        crawler.setup_scraper { |scraper| @scraper = scraper}
        expect(@scraper).to be crawler.scraper
      end
    end
  end

  describe "#setup_router, #routes" do
    context "without Proc given" do
      it "returns the Router" do
        expect(crawler.router).to be_a Router
      end
    end

    context "with Proc of arity 0 given" do
      it "evaluates the given Proc in its Router's instance context" do
        this = nil
        crawler.setup_router { this = self }
        expect(this).to be crawler.router
      end
    end

    context "with Proc of arity 1 given" do
      it "yields the Router" do
        crawler.setup_router { |router| @router = router }
        expect(@router).to be crawler.router
      end
    end
  end

end