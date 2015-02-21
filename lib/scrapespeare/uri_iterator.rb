require "active_support/core_ext/hash"

module Scrapespeare
  class URIIterator

    include Enumerable

    attr_reader :uri
    attr_reader :rule_set

    def initialize(base_uri, rule_set = {})
      @uri = URI(base_uri)
      @rule_set = rule_set
    end

    def each
      param = @rule_set[:param]

      loop do
        @uri.increment_query_param(param)
        yield @uri
      end
    end

  end
end
