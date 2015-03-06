require "spec_helpers"

describe Scrapespeare::Routing::Router do

  subject(:router) { Router.new }

  describe "#register" do
    it "builds a Rule used as key" do
      expect {
        router.register "/foo", :foo
      }.to change{ router.routing_table.keys.count }.by(1)
    end
  end

end
