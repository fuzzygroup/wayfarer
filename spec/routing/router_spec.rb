require "spec_helpers"

describe Scrapespeare::Routing::Router do

  subject(:router) { Router.new }

  describe "#register" do
    it "registers a Scraper associated with a Rule" do
      expect {
        router.register("/foo", :foobar)
      }.to change{ router.routing_table.keys.count }.by(1)
    end
  end

end
