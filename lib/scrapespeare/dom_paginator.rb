module Scrapespeare
  class DOMPaginator < Paginator

    def initialize(scraper, uri, matcher)
      super(scraper, uri)
      @matcher = matcher
    end

    private
    def successor_uri
      # matched_nodes = @matcher.match(@doc)
    end

  end
end
