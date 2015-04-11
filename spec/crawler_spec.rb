require "spec_helpers"

describe Schablone::Crawler do
  let(:crawler) { subject.class.new }

  describe "#register_scraper, #scraper" do
    context "with `Object` given" do
      let(:scraper) { Object.new }

      it "stores the `Object`" do
        expect {
          crawler.register_scraper(:foo, scraper)
        }.to change { crawler.scraper_table.length }.by(1)
      end
    end

    context "with bound `Proc` given" do
      it "stores the `Proc`" do
        expect {
          crawler.register_scraper(:foo, &Proc.new {})
        }.to change { crawler.scraper_table.length }.by(1)
      end
    end

    context "with both `Object` and bound `Proc` given" do
      let(:scraper) { Object.new }

      it "stores the `Object`" do
        crawler.register_scraper(:foo, scraper, &Proc.new {})
        expect(crawler.scraper_table[:foo]).to be scraper
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
