module Scrapespeare
  class Paginator

    attr_reader :http_adapter
    attr_reader :parser

    def initialize(http_adapter, parser)
      @http_adapter = HTTPClient.new
      @parser = parser
    end

    def paginate(uri)
      @uri = uri

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
