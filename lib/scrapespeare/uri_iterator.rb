module Scrapespeare
  class URIIterator

    include Enumerable

    attr_reader :uri
    attr_reader :opts

    def initialize(base_uri, opts = {})
      @uri = URI(base_uri)
      @opts = opts
    end

    def each
      infinity = 1.0 / 0 # => Infinity

      step        = @opts[:step] || 1
      lower_bound = @opts[:from] || 1
      upper_bound = @opts[:to]   || infinity

      range = (lower_bound..upper_bound)

      yield @uri

      range.to_enum.each do
        @uri.increment_query_param(@opts[:param], step)
        yield @uri
      end
    end

  end
end
