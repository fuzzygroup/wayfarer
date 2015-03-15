require "spec_helpers"

describe Scrapespeare::Routing::Router do

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

end
