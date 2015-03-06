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

  describe "#route" do
    context "with mismatching URI path given" do
      before { router.register("/foo", :foo) }

      it "returns `nil`" do
        uri = URI("http://google.com/bar")
        expect(router.route(uri)).to be nil
      end
    end

    context "with matching URI path given" do
      before do
        router.register("/*catchall", :catchall)
        router.register("/foo", :foo)
      end

      it "returns the first matching Rule's associated Scraper" do
        uri = URI("http://google.com/bar")
        expect(router.route(uri)).to be :catchall
      end
    end
  end

end
