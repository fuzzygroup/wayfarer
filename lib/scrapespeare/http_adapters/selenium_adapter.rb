module Scrapespeare
  module HTTPAdapters
    class SeleniumAdapter

      # Initializes a WebDriver, navigates to `uri` and returns the page source
      #
      # @param uri [String]
      def self.fetch(uri)
        web_driver = Selenium::WebDriver.for(:firefox)
        web_driver.navigate.to(uri)

        page_source = web_driver.page_source

        web_driver.close

        page_source
      end

    end
  end
end
