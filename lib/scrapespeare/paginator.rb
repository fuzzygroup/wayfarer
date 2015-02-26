module Scrapespeare
  class Paginator

    def initialize(scraper)
      @scraper      = scraper
      @http_adapter = HTTPAdapters::NetHTTPAdapter.new
    end

    def paginate(uri)
      @current_uri = uri

      catch(:pagination_ended) do
        loop do
          doc = fetch_response_body
          yield @scraper.extract(doc)
          @current_uri = successor_uri(doc)
        end
      end
    end

    private
    def fetch_response_body
      _, response_body, _ = @http_adapter.fetch(@current_uri)
      Parser.parse(response_body)
    end

  end
end
