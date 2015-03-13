require "spec_helpers"

describe Scrapespeare::Routing::Router do

  subject(:router) { Router.new }

  describe "#register" do
    it "works" do
      expect {
        router.register("/foo", :bar)
      }.to change { router.routes.count }.by(1)
    end
  end

end
