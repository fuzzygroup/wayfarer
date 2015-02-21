module Scrapespeare
  class URIIterator

    include Enumerable

    attr_reader :uri
    attr_reader :opts

    def initialize(base_uri, opts = {})
      @uri = URI(base_uri)
      @opts = opts

      fail "No parameter given" unless @opts[:param]
    end

    def each
      yield @uri

      # FIXME Don't bomb memory
      # Calling #set_query_param on @uri somehow won't work...
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

  end
end
