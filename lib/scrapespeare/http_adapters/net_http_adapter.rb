require "net/http"

module Scrapespeare
  module HTTPAdapters
    class NetHTTPAdapter

      def fetch(uri, redirect_count = 0)
        res = get_response(uri)

        if res.is_a? Net::HTTPRedirection
          redirect_location = URI(res["location"])
          fetch(redirect_location, redirect_count + 1)
        end

        [res.code.to_i, res.body, res.to_hash]
      end

      private
      def get_response(uri)
        Net::HTTP.get_response(uri)
      end

    end
  end
end
