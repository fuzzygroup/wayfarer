require "net/http"

module Scrapespeare
  module HTTPAdapters
    class NetHTTPAdapter

      def fetch(uri, redirects_followed = 0)
        res = Net::HTTP.get_response(uri)

        if res.is_a? Net::HTTPRedirection
          if redirects_followed == Scrapespeare.config.max_http_redirects
            fail "Maximum number of HTTP redirects reached"
          end

          redirect_location = URI(res["location"])
          fetch(redirect_location, redirects_followed + 1)
        else
          [res.code.to_i, res.body, res.to_hash]
        end
      end

    end
  end
end
