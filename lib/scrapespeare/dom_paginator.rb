module Scrapespeare
  class DOMPaginator

    attr_accessor :history
    attr_reader   :halt_cause

    def initialize(scraper, matcher_hash)
      @scraper      = scraper
      @http_adapter = HTTPAdapters::NetHTTPAdapter.new
      @history      = []
      @matcher = Matcher.new(matcher_hash)
    end

    def paginate(uri)
      @halt_cause = catch :halt do
        current_uri = uri

        loop do
          update_history(current_uri)
          response_body = fetch(current_uri)
          doc = Parser.parse(response_body)
          yield @scraper.extract(doc)
          current_uri = next_uri(current_uri, doc)
        end
      end
    end
    

    private
    def halt(cause)
      throw :halt, cause
    end

    def fetch(uri)
      status_code, response_body, _ = @http_adapter.fetch(uri)

      if status_code > 299 # TODO Don't be THAT naive
        halt :followed_dead_link
      else
        response_body
      end
    end

    def update_history(uri)
      @history.include?(uri) ? (halt :uri_already_visited) : @history.push(uri)
    end

    def next_uri(uri, doc)
      href_attr = Evaluator.evaluate_attribute(pagination_element(doc), :href)
      URI.join(uri, href_attr)
    end

    def pagination_element(doc)
      matched_nodes = @matcher.match(doc)

      if matched_nodes.empty?
        halt :no_pagination_element
      elsif matched_nodes.count > 1
        halt :ambiguous_pagination_element
      else
        matched_nodes.first
      end
    end

  end
end
