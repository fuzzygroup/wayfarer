require "spec_helpers"

describe Scrapespeare::Routing::Router do

  subject(:router) { Router.new }

  describe "#allow" do
    it "evaluates the given Proc in its `@whitelist`'s instance context" do
      this = nil
      router.allow { this = self }
      expect(this).to be router.whitelist
    end
  end

  describe "#forbid" do
    it "evaluates the given Proc in its `@blacklist`'s instance context" do
      this = nil
      router.forbid { this = self }
      expect(this).to be router.blacklist
    end
  end

end
