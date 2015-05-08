require "spec_helpers"

describe Schablone::Routing::Router do
  subject(:router) { Router.new }

  describe "#register_scraper" do
    it "registers a scraper" do
      expect {
        router.register_scraper(:foo, Object.new)
      }.to change { router.scrapers.count }.by(1)
    end
  end

  describe "#draw" do
    it "appends a routes" do
      expect { router.draw(:foo) }.to change { router.routes.count }.by(1)
    end

    it "evaluates the Proc in a Rule's instance context" do
      this = nil
      router.draw(:foo) { this = self }
      expect(this).to be_a Rule
    end
  end
end
