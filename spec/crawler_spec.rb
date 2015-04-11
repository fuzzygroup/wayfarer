require "spec_helpers"

describe Schablone::Crawler do
  let(:crawler) { subject.class.new }

  describe "#register_scraper, #scraper" do
    it "registers a route target" do
      expect {
        crawler.register_scraper(:foo, &Proc.new {})
      }.to change { crawler.router.targets.count }.by(1)
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
