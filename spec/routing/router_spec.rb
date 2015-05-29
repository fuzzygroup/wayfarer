require "spec_helpers"

describe Schablone::Routing::Router do
  subject(:router) { Router.new }

  describe "#forbid" do
    it "forbids URIs" do
      router.forbid host: "example.com"
      expect(router.forbids?(URI("http://example.com"))).to be true

      router.forbid do
        host "google.com"
      end

      expect(router.forbids?(URI("http://google.com"))).to be true
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
      expect(router.route(URI("http://example.com/foo"))).to be_truthy
    end
  end

  describe "#route" do
    context "with matching route" do
      it "returns the registered payload and parameters" do
        router.draw(:foo) { host "example.com", path: "/{barqux}" }
        uri = URI("http://example.com/42")
        method, params = router.route(uri)
        expect(method).to be :foo
        expect(params).to eq({ "barqux" => "42" })
      end
    end

    context "without matching route" do
      it "returns false" do
        router.draw(:foo) { host "example.com", path: "/{barqux}" }
        uri = URI("http://google.com")
        method, params = router.route(uri)
        expect(method).to be false
        expect(params).to be nil
      end
    end

    context "with forbidden URI" do
      it "returns false" do
        router.forbid.host("example.com")
        expect(router.route(URI("http://example.com"))).to be false
      end
    end
  end
end
