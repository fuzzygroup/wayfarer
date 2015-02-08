module Scrapespeare
  module HTTPAdapters
    class SeleniumAdapter

      include Scrapespeare::Callbacks

      # Navigates to `uri` and returns the page source
      #
      # @param uri [String]
      def fetch(uri)
        web_driver = Selenium::WebDriver.for(:firefox)
        web_driver.navigate.to(uri)

        execute_callbacks(:before, web_driver)

        page_source = web_driver.page_source

        web_driver.close

        page_source
      end

      private
      def web_driver
        return @http_adapter if @http_adapter

        case options[:http_adapter]
        when :net_http
          @http_adapter = Scrapespeare::HTTPAdapters::NetHTTPAdapter.new
        when :selenium
          @http_adapter = Scrapespeare::HTTPAdapters::SeleniumAdapter.new
        else
          fail "Unknown HTTP adapter `#{@options[:http_adapter]}`"
        end
      end

    end
  end
end
