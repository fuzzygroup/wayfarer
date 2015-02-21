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
      yield @uri

      infinity = 1.0 / 0 # => Infinity

      param       = @opts[:param]
      lower_bound = @opts[:from] || 2
      upper_bound = @opts[:to]   || infinity

      range = (2..infinity)

      # FIXME Don't bomb memory
      range.each do |i, uri = @uri.clone|
        uri.set_query_param(param, i)
        yield uri
      end
    end

  end
end
