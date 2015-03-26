require "net/http"

module Schablone
  class Fetcher
    def fetch(uri, redirects_followed = 0)
      fail if redirects_followed > Schablone.config.max_http_redirects

      res = Net::HTTP.get_response(uri)

      if res.is_a? Net::HTTPRedirection
        redirect_uri = URI(res["location"])
        return fetch(redirect_uri, redirects_followed + 1)
      end

      status_code = res.code.to_i
      body        = res.body
      headers     = res.to_hash

      Page.new(uri, status_code, body, headers)
    end
  end
end
