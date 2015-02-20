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
      loop do
        response_body = @http_adapter.fetch(uri)
        doc = @parser.parse(response_body)

        yield doc

        break unless has_successor_uri?
      end
    end

    private
    def has_successor_uri?
      !!successor_uri
    end

    def successor_uri
      nil
    end

  end
end
