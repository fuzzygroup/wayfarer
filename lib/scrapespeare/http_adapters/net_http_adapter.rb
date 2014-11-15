module Scrapespeare
  module HTTPAdapters
    class NetHTTPAdapter

      # Fires a HTTP GET request against the URI and returns the response body
      #
      # @param uri [String]
      def self.fetch(uri)
        response = Net::HTTP.get_response(URI(uri))

        if response.code == "301" && response["location"]
          fetch(response["location"])
        else
          response.body
        end
      end

    end
  end
end
