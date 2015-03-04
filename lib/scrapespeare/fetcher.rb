require "net/http"

module Scrapespeare
  module HTTPAdapters
    class NetHTTPAdapter

      def fetch(uri)
        res = Net::HTTP.get_response(URI(uri))

        headers     = res.to_h
        status_code = res.code
        body        = res.body

        Page.new(response_body, body, headers)
      end

    end
  end
end
