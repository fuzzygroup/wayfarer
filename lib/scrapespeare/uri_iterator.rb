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
      enum = (1..infinity).to_enum

      yield @uri

      enum.each do
        @uri.increment_query_param(@opts[:param])
        yield @uri
      end
    end

  end
end
