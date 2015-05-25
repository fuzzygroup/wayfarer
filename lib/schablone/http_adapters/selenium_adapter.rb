require "selenium-webdriver"
# require "selenium/emulated_features"

module Schablone
  module HTTPAdapters
    class SeleniumAdapter
      def initialize
        @driver = Selenium::WebDriver.for(*Schablone.config.selenium_argv)
      end

      def fetch(uri)
        @driver.navigate.to(uri)

        uri         = @driver.current_url
        status_code = @driver.response_code
        body        = @driver.page_source
        headers     = @driver.response_headers

        Page.new(
          uri: uri,
          status_code: status_code,
          body: body,
          headers: headers
        )
      end

      def free
        @driver.quit
      end

    end
  end
end
