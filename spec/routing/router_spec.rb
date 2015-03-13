require "spec_helpers"

describe Scrapespeare::Routing::Router do

  subject(:router) { Router.new }

  describe "#register" do
    it "stores a Route" do
      expect {
        router.register("/foo", :bar)
      }.to change { router.routes.count }.by(1)
    end

    it "stores Routes in FIFO order" do
      router.register("/foo", :foo)
      router.register("/bar", :bar)
    end

    it "returns the stored Route" do
      returned = router.register("/foo", :bar)
      expect(returned).to be_a Route
    end
  end

end
