module Scrapespeare
  module HTTPAdapters
    class NetHTTPAdapter

      include Callbacks

      # Fires a HTTP GET request against the URI and returns the response body
      #
      # @param uri [String]
      def fetch(uri, redirects_followed = 0)
        if redirects_followed == Scrapespeare.config.max_http_redirects
          
        end

        res = Net::HTTP.get_response(URI(uri))

        execute_callbacks(:before, res)

        if is_redirect?(res)
          fetch(res["location"], redirects_followed + 1)
        else
          res.body
        end
      end

      private
      def is_redirect?(res)
        res.code == "301" && res["location"]
      end

    end
  end
end
