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
      route_a = router.register("/foo", :foo)
      route_b = router.register("/bar", :bar)

      expect(router.routes).to eq [route_a, route_b]
    end

    it "returns the stored Route" do
      returned = router.register("/foo", :bar)
      expect(returned).to be_a Route
    end
  end

  describe "#invoke" do
    context "with matching URI" do
      before do
        router.register("/foo", :foo)
        router.register("/*catch_all", :catch_all)
      end

      it "returns the first matching Route's Scraper Symbol" do
        uri = URI("http://example.com/foo")
        returned = router.invoke(uri)
        expect(returned).to be :foo
      end
    end

    context "with mismatching URI" do
      before do
        router.register("/foo", :foo)
      end

      it "returns `nil`" do
        uri = URI("http://example.com/baz")
        returned = router.invoke(uri)
        expect(returned).to be nil
      end
    end
  end

end
