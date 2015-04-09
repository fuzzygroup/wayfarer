require "spec_helpers"

describe Schablone::Routing::Router do
  subject(:router) { Router.new }

  describe "#allow" do
    context "with Proc given" do
      it "evaluates the given Proc in its `@whitelist`'s instance context" do
        this = nil
        router.allow { this = self }
        expect(this).to be router.whitelist
      end
    end

    context "without Proc given" do
      it "returns its `@whitelist`" do
        expect(router.allow).to be router.whitelist
      end
    end
  end

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

  describe "#allows?" do
    let(:uri) { URI("http://example.com/foo") }

    it "returns `false` for all URIs as default" do
      expect(router.allows?(uri)).to be false
    end

    context "with whitelisted URI given" do
      before { router.allow.host("example.com") }

      it "returns `true`" do
        expect(router.allows?(uri)).to be true
      end
    end

    context "with blacklisted URI given" do
      before { router.forbid.host("example.com") }
      before { router.allow.path("/foo") }

      it "returns `false`" do
        expect(router.allows?(uri)).to be false
      end
    end

    context "with both black- and whitelisted URI given" do
      before do
        router.forbid.host("example.com")
        router.allow.host("example.com")
      end

      it "returns `false`" do
        expect(router.allows?(uri)).to be false
      end
    end
  end

  describe "#map" do
    it "registers a Route" do
      expect {
        router.map(:foo) {}
      }.to change { router.routes.count }.by(1)
    end

    it "evaluates the Proc in a `Rule`'s instance context" do
      this = nil
      router.map(:foo) { this = self }
      expect(this).to be_a Rule
    end
  end
end
