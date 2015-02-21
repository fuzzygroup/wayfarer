module Scrapespeare
  class URIIterator

    include Enumerable

    def initialize(base_uri, opts = {})
      @uri = URI(base_uri)
      @opts = opts

      fail "A parameter to iterate over is missing" unless @opts[:param]
    end

    def each
      yield @uri

      if values
        # FIXME Don't bomb memory
        values.each do |val, uri = @uri.clone|
          uri.set_query_param(param, val)
          yield uri
        end

        return
      end

      # FIXME Don't bomb memory
      (lower_bound..upper_bound).step(step).each do |i, uri = @uri.clone|
        uri.set_query_param(param, i.to_i)
        yield uri
      end
    end

    private
    def param
      @opts[:param]
    end

    def lower_bound
      if from_opts = @opts[:from]
        from_opts
      elsif from_uri = @uri.get_query_param(param)
        from_uri.to_i + 1
      else
        2
      end
    end

    def upper_bound
      infinity = 1.0 / 0
      @opts[:to] || infinity
    end

    def step
      @opts[:step] || 1
    end

    def values
      @opts[:values]
    end

  end
end
