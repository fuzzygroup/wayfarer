require "spec_helpers"

module Scrapespeare
  module HTTPAdapters
    describe SeleniumAdapter do
      before do
        WebMock.disable_net_connect!(allow: "127.0.0.1")
      end

      let(:adapter) { SeleniumAdapter.new }

      describe "#fetch", live: true do
        it "returns the HTTP response body" do
          response_body = adapter.fetch("http://example.com")
          expect(response_body).to match /Example Domain/
        end

        it "executes its callbacks and yields a WebDriver" do
          callback = Proc.new { |web_driver| @web_driver = web_driver }
          adapter.register_callback(:before, &callback)
  
          adapter.fetch("http://example.com")

          expect(@web_driver).to be_a Selenium::WebDriver::Driver
        end
      end

      describe "#web_driver" do
        after { adapter.instance_variable_get(:@web_driver).close }

        it "returns a Selenium::WebDriver" do
          expect(adapter.send(:web_driver)).to be_a Selenium::WebDriver::Driver
        end
      end

    end
  end
end
