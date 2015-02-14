module Scrapespeare
  class DOMPaginator < Paginator

    def initialize(scraper, uri, matcher_hash)
      super(scraper, uri)
      @matcher = Matcher.new(matcher_hash)
    end

    private
    def successor_uri
      case matched_nodes.count
      when 0 then nil
      when 1
        element = matched_nodes.first
        path = Evaluator.evaluate_attribute(element, "href")
        URIConstructor.construct(@uri, path)
      else
        fail "More than 1 element"
      end
    end

    def matched_nodes
      matched_nodes = @matcher.match(@doc)
    end

  end
end
