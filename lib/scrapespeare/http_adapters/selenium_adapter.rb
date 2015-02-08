module Scrapespeare
  module HTTPAdapters
    class SeleniumAdapter

      include Callbacks

      # Navigates to `uri` and returns the page source
      #
      # @param uri [String]
      def fetch(uri)
        web_driver.navigate.to(uri)
        execute_callbacks(:before, web_driver)
        page_source = web_driver.page_source
        web_driver.close
        page_source
      end

      private
      def web_driver
        @web_driver ||= Selenium::WebDriver.for(:firefox)
      end

    end
  end
end
