module Scrapespeare
  class URIPaginator < Paginator

    attr_reader :rule_set

    def initialize(http_adapter, parser, rule_set)
      super(http_adapter, parser)
      @rule_set = rule_set
    end

  end
end
