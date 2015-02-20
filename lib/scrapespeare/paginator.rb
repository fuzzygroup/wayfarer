module Scrapespeare
  class Paginator

    attr_reader :http_adapter
    attr_reader :parser
    attr_reader :state

    def initialize(http_adapter, parser)
      @http_adapter = http_adapter
      @parser = parser

      @state = {}
    end

    def paginate(uri)
      yield successor_doc while has_successor_doc?
    end

    private
    def has_successor_doc?
      !!successor_doc
    end

    def successor_doc
      nil
    end

  end
end
