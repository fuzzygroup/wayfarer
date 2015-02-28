require "set"

module Scrapespeare
  class Paginator

    attr_accessor :history

    def initialize(scraper)
      @scraper      = scraper
      @http_adapter = HTTPAdapters::NetHTTPAdapter.new
      @history      = []
    end

    def paginate(uri)
      catch :pagination_ended do
        current_uri = uri

        loop do
          @history.push(current_uri)

          response_body = fetch(current_uri)
          doc = Parser.parse(response_body)

          yield @scraper.extract(doc)

          current_uri = next_uri(current_uri, doc)
        end
      end
    end

    private
    def fetch(uri)
      _, response_body, _ = @http_adapter.fetch(uri)
      response_body
    end

  end
end
