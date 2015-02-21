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
      upper_bound = @rule_set[:to]

      if upper_bound
        (upper_bound + 1).times do
          yield @uri
          @uri.increment_query_param(param)
        end
      else
        loop do
          yield @uri
          @uri.increment_query_param(param)
        end
      end
    end

  end
end
