module Scrapespeare
  class DOMPaginator < Paginator

    attr_reader :matcher

    def initialize(http_adapter, parser, matcher_hash)
      super(http_adapter, parser)
      @matcher = Matcher.new(matcher_hash)
    end

    def paginate(uri)
    end

    private
    def matched_nodes
    end

  end
end
