module Scrapespeare
  class DOMPaginator < Paginator

    def initialize(scraper, matcher_hash)
      super(scraper)

      @matcher = Matcher.new(matcher_hash)
    end

    private
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
