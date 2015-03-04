require "net/http"

module Scrapespeare
  class Fetcher

    def fetch(uri)
      res = Net::HTTP.get_response(uri)

      status_code = res.code.to_i
      body        = res.body
      headers     = res.to_hash

      Page.new(status_code, body, headers)
    end

  end
end
