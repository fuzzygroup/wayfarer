require "spec_helpers"

describe Scrapespeare::Routing::Router do

  subject(:router) { Router.new }

  describe "#register" do
    it "builds a Rule used as key" do
      expect {
        router.register("/foo", :foo)
      }.to change{ router.routing_table.keys.count }.by(1)
    end
  end

  describe "#recognized?" do
    before { router.register("/foo", :foo) }

    context "with matching URI path given" do
      it "returns `true`" do
        uri = URI("http://google.com/foo")
        expect(router.recognized?(uri)).to be true
      end
    end

    context "with mismatching URI path given" do
      it "returns `true`" do
        uri = URI("http://google.com/bar")
        expect(router.recognized?(uri)).to be false
      end
    end
  end

end
