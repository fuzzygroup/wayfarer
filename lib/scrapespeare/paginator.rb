require "set"

module Scrapespeare
  class Paginator

    attr_accessor :history

    def initialize(scraper)
      @scraper      = scraper
      @http_adapter = HTTPAdapters::NetHTTPAdapter.new
      @history = Set.new([])
    end

    def paginate(uri)
      @current_uri = uri

      catch :pagination_ended do
        loop do
          doc = Parser.parse(fetch_response_body)
          yield @scraper.extract(doc)
          @current_uri = successor_uri(doc)
        end
      end
    end

    private
    def fetch_response_body
      _, response_body, _ = @http_adapter.fetch(@current_uri)
      response_body
    end

  end
end
