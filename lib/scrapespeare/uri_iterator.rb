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
      param = @opts[:param]
      upper_bound = @opts[:to]
      step = @opts[:step] || 1

      if upper_bound
        (upper_bound + 1).times do
          yield @uri
          @uri.increment_query_param(param, step)
        end
      else
        loop do
          yield @uri
          @uri.increment_query_param(param, step)
        end
      end
    end

    private
    def increment_uri
    end

  end
end
