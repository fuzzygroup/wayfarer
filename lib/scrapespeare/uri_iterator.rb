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
    end

    private
    def set_query_param(param, val)
      @uri.query = @uri.parsed_query.merge({ param => val }).to_query
    end

  end
end
