module Scrapespeare
  class DOMPaginator

    def initialize(scraper, matcher_hash)
      @scraper      = scraper
      @matcher      = Matcher.new(matcher_hash)
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

    def pagination_element(doc)
      matched_nodes = @matcher.match(doc)

      if matched_nodes.empty? || matched_nodes.count > 1
        throw :pagination_ended
      else
        matched_nodes.first
      end
    end

    def successor_uri(doc)
      href_attr = Evaluator.evaluate_attribute(pagination_element(doc), :href)
      URI.join(@current_uri, href_attr)
    end

  end
end
