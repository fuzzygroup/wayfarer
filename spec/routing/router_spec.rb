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

  describe "#register_handler" do
    it "register_handlers a route target" do
      expect {
        router.register_handler(:foo, &Proc.new {})
      }.to change { router.handlers.count }.by(1)
    end
  end

  describe "#map" do
    it "register_handlers a route" do
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
      router.register_handler(:foo, &scraper_a)
      router.register_handler(:bar, &scraper_b)
      router.map(:foo) { host "example.com" }
    end

    context "with URI recognized by 1 route" do
      it "returns the handler's key `Symbol`" do
        sym, _ = router.invoke(uri)
        expect(sym).to be :foo
      end

      it "returns the handler's associated `Proc`" do
        _, proc = router.invoke(uri)
        expect(proc).to be scraper_a
      end
    end

    context "with URI recognized by >= 1 routes" do
      before { router.map(:bar) { host "example.com" } }

      it "returns the first matched handler" do
        _, proc = router.invoke(uri)
        expect(proc).to be scraper_a
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
