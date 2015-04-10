require "spec_helpers"

describe Schablone::Routing::Router do
  let(:scraper) { Object.new }
  subject(:router) { Router.new({}) }

  describe "#forbid" do
    context "with Proc given" do
      it "evaluates the given Proc in its `@blacklist`'s instance context" do
        this = nil
        router.forbid { this = self }
        expect(this).to be router.blacklist
      end
    end

    context "without Proc given" do
      it "returns its `@blacklist`" do
        expect(router.forbid).to be router.blacklist
      end
    end
  end

  describe "#map" do
    it "registers a route" do
      expect { router.map(:foo) }.to change { router.routes.count }.by(1)
    end

    it "evaluates the Proc in a `Rule`'s instance context" do
      this = nil
      router.map(:foo) { this = self }
      expect(this).to be_a Rule
    end
  end

  describe "#invoke" do
    let(:uri) { URI("http://example.com") }
    let(:scraper_table) { {} }
    subject(:router) { Router.new(scraper_table) }
    before do
      scraper_table[:foo] = 0
      scraper_table[:bar] = 1
      router.map(:foo) { host "example.com" }
    end

    context "with recognized URI" do
      it "returns the associated `Scraper`" do
        expect(router.invoke(uri)).to be 0
      end
    end

    context "with URI recognized by multiple `Rule`s" do
      before { router.map(:bar) { host "example.com" } }

      it "returns the first matching `Rule`s associated `Symbol`" do
        expect(router.invoke(uri)).to be 0
      end
    end

    context "with unrecognized URI" do
      it "returns `nil`" do
        uri = URI("http://unrecognized.com")
        expect(router.invoke(uri)).to be nil
      end
    end
  end
end
