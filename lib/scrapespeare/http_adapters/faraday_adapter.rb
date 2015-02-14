module Scrapespeare
  module HTTPAdapters
    class FaradayAdapter

      def initialize
        @client = Faraday.new
      end

      # Fires a HTTP GET request against the URI and returns the response body
      #
      # @param uri [String]
      def fetch(uri)
        @client.get(uri).body
      end

    end
  end
end
