require "spec_helpers"

module Scrapespeare
  module HTTPAdapters
    describe SeleniumAdapter do
      let(:adapter) { SeleniumAdapter.new }

      before { WebMock.allow_net_connect! }

      describe "#initialize", live: true do
        after { adapter.release_driver }

        it "initializes a new WebDriver" do
          expect(adapter.driver).to be_a Selenium::WebDriver::Driver
        end
      end

      describe "#release_driver", live: true do
        it "quits the driver" do
          adapter.release_driver
          expect(adapter.driver).to be nil
        end
      end

      describe "#fetch", live: true do
        after { adapter.release_driver }

        it "returns the page source" do
          expect(adapter.fetch("http://example.com")).to match /Example Domain/
        end
      end

    end
  end
end
