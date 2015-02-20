module Scrapespeare
  class Paginator

    attr_reader :http_adapter
    attr_reader :parser
    attr_reader :state

    def initialize(http_adapter, parser)
      @http_adapter = http_adapter
      @parser = parser
    end

    def paginate(uri)
      while succ_doc = successor_doc
        yield succ_doc
      end
    end

    private
    def successor_doc
      nil
    end

  end
end
