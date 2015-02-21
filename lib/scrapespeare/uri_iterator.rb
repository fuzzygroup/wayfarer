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
      step        = @opts[:step] || 1

      # FIXME Don't bomb memory
      (lower_bound..upper_bound).step(step).each do |i, uri = @uri.clone|
        uri.set_query_param(param, i.to_i)
        yield uri
      end
    end

  end
end
