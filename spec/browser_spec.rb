require "spec_helpers"

module Scrapespeare
  describe Browser do

    describe "#initialize" do
      it "works" do
        browser = Browser.new
        browser.session.visit "http://google.com"
      end
    end

  end
end
