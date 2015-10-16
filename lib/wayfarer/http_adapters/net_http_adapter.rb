require "singleton"
require "net/http"
require "net/http/persistent"

module Wayfarer
  module HTTPAdapters
    class NetHTTPAdapter
      include Singleton

      RECOGNIZED_URI_TYPES = [
        URI::HTTP,
        URI::HTTPS
      ]

      class MalformedURI < StandardError; end
      class MalformedRedirectURI < StandardError; end
      class MaximumRedirectCountReached < StandardError; end

      def initialize
        @conn = Net::HTTP::Persistent.new("schablone")
      end

      def fetch(uri, redirects_followed = 0)
        if !RECOGNIZED_URI_TYPES.include?(uri.class)
          fail redirects_followed > 0 ? MalformedRedirectURI : MalformedURI
        elsif redirects_followed > Wayfarer.config.max_http_redirects
          fail MaximumRedirectCountReached
        end

        res = @conn.request(uri)

        if res.is_a?(Net::HTTPRedirection)
          redirect_uri = URI(res["location"])
          return fetch(redirect_uri, redirects_followed + 1)
        end

        Page.new(
          uri: uri,
          status_code: res.code.to_i,
          body: res.body,
          headers: res.to_hash
        )

      rescue SocketError
        fail MalformedURI
      end

      def free
        @conn.shutdown
      end
    end
  end
end
