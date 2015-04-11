require "spec_helpers"

describe Schablone::Routing::Router do
  let(:scraper)    { Object.new }
  subject(:router) { Router.new }

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

  describe "#register" do
    it "registers a route target" do
      expect {
        router.register(:foo, &Proc.new {})
      }.to change { router.targets.count }.by(1)
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
    let(:scraper_a) { Proc.new {} }
    let(:scraper_b) { Proc.new {} }

    before do
      router.register(:foo, &scraper_a)
      router.register(:bar, &scraper_b)
      router.map(:foo) { host "example.com" }
    end

    context "with URI recognized by 1 route" do
      it "returns the matched target" do
        expect(router.invoke(uri)).to be scraper_a
      end
    end

    context "with URI recognized by >= 1 routes" do
      before { router.map(:bar) { host "example.com" } }

      it "returns the first matched target" do
        expect(router.invoke(uri)).to be scraper_a
      end
    end

    context "with URI recognized by 0 route" do
      it "returns `nil`" do
        uri = URI("http://unrecognized.com")
        expect(router.invoke(uri)).to be nil
      end
    end
  end
end
