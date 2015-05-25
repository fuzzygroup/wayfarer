require "spec_helpers"

describe Schablone::Crawler do
  let(:crawler) { Crawler.new }

  describe "#let" do
    it "creates threadsafe locals" do
      crawler.let :foo, Object.new
      expect(crawler.locals[:foo]).to be_a Threadsafe
    end
  end

  describe "#let!" do
    it "creates locals" do
      crawler.let! :foo, obj = Object.new
      expect(crawler.locals[:foo]).to be obj
    end
  end

  describe "#router" do
    context "without Proc given" do
      it "returns the Router" do
        expect(crawler.router).to be_a Router
      end
    end

    context "with Proc of arity 0 given" do
      it "evaluates the given Proc in its Router's instance context" do
        this = nil
        crawler.router { this = self }
        expect(this).to be crawler.router
      end
    end

    context "with Proc of arity 1 given" do
      it "yields the Router" do
        crawler.router { |router| @router = router }
        expect(@router).to be crawler.router
      end
    end
  end
end
