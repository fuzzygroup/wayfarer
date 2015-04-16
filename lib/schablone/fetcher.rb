require "net/http"
require "net/http/persistent"

module Schablone
  class Fetcher

    class MaximumRedirectCountReached < StandardError; end
    class MalformedRedirectURI < StandardError; end

    def initialize
      @conn = Net::HTTP::Persistent.new("schablone")
    end

    def fetch(uri, redirects_followed = 0)
      if redirects_followed > Schablone.config.max_http_redirects
        fail MaximumRedirectCountReached
      end

      res = @conn.request(uri)

      if res.is_a? Net::HTTPRedirection
        redirect_uri = URI(res["location"])
        return fetch(redirect_uri, redirects_followed + 1)
      end

      status_code = res.code.to_i
      body        = res.body
      headers     = res.to_hash

      Page.new(uri, status_code, body, headers)
    end

    def free
      @conn.shutdown
    end
  end
end
