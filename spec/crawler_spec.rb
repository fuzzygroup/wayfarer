require "spec_helpers"

describe Scrapespeare::Crawler do

  let(:crawler) { subject.class.new }

  describe "#setup_scraper, #scraper" do
    context "with Proc given" do
      it "evaluates the given Proc in its Scraper's instance context" do
        this = nil
        crawler.setup_scraper { |scraper| this = scraper }
        expect(this).to be crawler.scraper
      end
    end

    context "without Proc given" do
      it "returns its Scraper" do
        expect(crawler.scraper).to be_a Scraper
      end
    end
  end

end