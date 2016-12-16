# frozen_string_literal: true
require "selenium-webdriver"
require "selenium/emulated_features"

module Wayfarer
  module HTTPAdapters
    # An adapter for Selenium WebDrivers
    # @private
    class SeleniumAdapter
      # @!attribute [r] driver
      # @return [URI] the Selenium WebDriver.
      attr_reader :driver

      def initialize(config)
        @config = config
      end

      # Fetches a page.
      # @return [Page]
      def fetch(uri)
        driver.navigate.to(uri)

        Page.new(
          uri: @driver.current_url,
          status_code: @driver.response_code,
          body: @driver.page_source,
          headers: @driver.response_headers
        )
      end

      # Closes and unsets the current driver.
      def reload!
        @driver.close if @driver
        @driver = nil
      end

      # Quits the browser.
      def free
        @driver.quit if @driver
        @driver = nil
      end

      # The WebDriver.
      def driver
        @driver ||= instantiate_driver
      end

      private

      def instantiate_driver
        driver = Selenium::WebDriver.for(*@config.selenium_argv)
        driver.manage.window.size = Selenium::WebDriver::Dimension.new(
          *@config.window_size
        )
        driver
      end
    end
  end
end
