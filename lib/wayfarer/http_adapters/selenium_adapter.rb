# frozen_string_literal: true
require "selenium-webdriver"
require "selenium/emulated_features"

module Wayfarer
  module HTTPAdapters
    # An adapter for Selenium WebDrivers
    class SeleniumAdapter
      # @!attribute [r] driver
      # @return [URI] the Selenium WebDriver.
      attr_reader :driver

      def initialize
        @driver = Selenium::WebDriver.for(*Wayfarer.config.selenium_argv)
        @driver.manage.window.size = Selenium::WebDriver::Dimension.new(
          *Wayfarer.config.window_size
        )
      end

      # Fetches a page.
      # @return [Page]
      def fetch(uri)
        @driver.navigate.to(uri)

        Page.new(
          uri: @driver.current_url,
          status_code: @driver.response_code,
          body: @driver.page_source,
          headers: @driver.response_headers
        )
      end

      # Quits the browser.
      def free
        @driver.quit
      end
    end
  end
end
