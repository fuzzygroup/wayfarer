require "net/http"

module Scrapespeare
  module HTTPAdapters
    class NetHTTPAdapter

      def fetch(uri)
        res = Net::HTTP.get_response(uri)

        [res.code.to_i, res.body, res.to_hash]
      end

    end
  end
end
