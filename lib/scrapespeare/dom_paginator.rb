module Scrapespeare
  class DOMPaginator

    def initialize(scraper, matcher_hash)
      @scraper      = scraper
      @matcher      = Matcher.new(matcher_hash)
      @http_adapter = HTTPAdapters::NetHTTPAdapter.new
      @parser       = Parser
    end

    def paginate(uri)
      _, response_body, _ = fetch(uri)
      doc = parse(response_body)
    end

    private
    def fetch(uri)
      @http_adapter.fetch(uri)
    end

    def parse(html_str)
      @parser.parse(html_str)
    end

    def pagination_element(doc)
      matched_nodes = @matcher.match(doc)

      if matched_nodes.empty?
        fail "NO MATCHED NODES"
      elsif matched_nodes.count > 1
        fail "MORE THAN ONE MATCHED NODES"
      else
        matched_nodes.first
      end
    end

  end
end
