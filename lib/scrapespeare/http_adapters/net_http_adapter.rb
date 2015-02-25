require "net/http"

module Scrapespeare
  module HTTPAdapters
    class NetHTTPAdapter

      def fetch(uri)
        res = Net::HTTP.get_response(uri)

        [
          res.code.to_i,
          nil,
          nil
        ]
      end

    end
  end
end
