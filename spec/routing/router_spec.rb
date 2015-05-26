require "spec_helpers"

describe Schablone::Routing::Router do
  subject(:router) { Router.new }

  describe "#register_payload" do
    it "registers a scraper" do
      expect {
        router.register_payload(:foo, &Proc.new {})
      }.to change { router.payloads.count }.by(1)
    end
  end

  describe "#draw" do
    it "appends a route" do
      expect { router.draw(:foo) }.to change { router.routes.count }.by(1)
    end

    it "evaluates the Proc in a Rule's instance context" do
      this = nil
      router.draw(:foo) { this = self }
      expect(this).to be_a Rule
    end

    it "builds the expected Rule chain" do
      router.draw(:foo, host: "example.com", path: "/foo")
      expect(router.route(URI("http://example.com/foo"))).to be true
    end
  end

  describe "#route" do
    context "with matching route" do
      it "returns the registered scraper and parameters" do
        router.register_payload(:foo, &(foo = Proc.new {}))
        router.draw(:foo) { host "example.com", path: "/{barqux}" }
        uri = URI("http://example.com/42")
        scraper, params = router.route(uri)
        expect(scraper).to be foo
        expect(params).to eq({ "barqux" => "42" })
      end
    end

    context "without matching route" do
      it "returns false" do
        router.register_payload(:foo, &(foo = Proc.new {}))
        router.draw(:foo) { host "example.com", path: "/{barqux}" }
        uri = URI("http://google.com")
        scraper, params = router.route(uri)
        expect(scraper).to be false
        expect(params).to be nil
      end
    end

    context "without registered scraper" do
      it "returns false" do
        router.draw(:foo) { host "example.com", path: "/{barqux}" }
        uri = URI("http://example.com/42")
        scraper, params = router.route(uri)
        expect(scraper).to be false
      end
    end
  end
end
