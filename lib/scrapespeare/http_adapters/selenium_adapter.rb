module Scrapespeare
  module HTTPAdapters
    class SeleniumAdapter

      attr_reader :driver

      def initialize
        @driver = Selenium::WebDriver.for(*Scrapespeare.config.selenium_argv)
      end

      # Navigates to `uri` and returns the page source
      #
      # @param uri [String]
      def fetch(uri)
        @driver.navigate.to(uri)
        @driver.page_source
      end

      def release_driver
        @driver.quit
        @driver = nil
      end

    end
  end
end
