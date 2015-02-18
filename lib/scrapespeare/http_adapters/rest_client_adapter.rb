module Scrapespeare
  module HTTPAdapters
    class RestClientAdapter

      # Navigates to `uri` and returns the page source
      #
      # @param uri [String]
      def fetch(uri)
        RestClient.get(uri)
      end

    end
  end
end
