module Scrapespeare
  class URIIterator

    include Enumerable

    attr_reader :base_uri
    attr_reader :rule_set

    def initialize(base_uri, rule_set = {})
      @base_uri = base_uri
      @rule_set = rule_set
    end

    def each
    end

  end
end
