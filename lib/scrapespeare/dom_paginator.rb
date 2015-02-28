module Scrapespeare
  class DOMPaginator < Paginator

    def initialize(scraper, matcher_hash)
      super(scraper)

      @matcher = Matcher.new(matcher_hash)
    end

    private
    def next_uri(uri, doc)
      href_attr = Evaluator.evaluate_attribute(pagination_element(doc), :href)
      URI.join(uri, href_attr)
    end

    def pagination_element(doc)
      matched_nodes = @matcher.match(doc)

      if matched_nodes.empty?
        throw :halt, :no_pagination_element
      elsif matched_nodes.count > 1
        throw :halt
      else
        matched_nodes.first
      end
    end

  end
end
