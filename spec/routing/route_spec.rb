require "spec_helpers"

describe Scrapespeare::Routing::Route do

  subject(:route) { Route.new("/foo", :bar) }

  describe "#invoke" do
    it "returns the Scraper Symbol" do
      expect(route.invoke).to be :bar
    end
  end

  describe "#matches?" do
    context "with matching URI given" do
      it "returns `true`" do
        uri = URI("http://google.com/foo")
        expect(route.matches?(uri))
      end
    end

    context "with mismatching URI given" do
      it "returns `false`" do
        uri = URI("http://google.com/qux")
        expect(!route.matches?(uri))
      end
    end
  end

end