module Scrapespeare
  class Paginator

    attr_reader :http_adapter
    attr_reader :parser

    def initialize(http_adapter, parser)
      @http_adapter = http_adapter
      @parser = parser

      @state = {}
    end

    def paginate(uri)
      @state[:uri] = uri

      loop do
        response_body = @http_adapter.fetch(uri)
        doc = @parser.parse(response_body)

        yield doc

        break unless has_successor?
      end
    end

    private
    def has_successor?
      @state[:uri] = successor_uri if successor_uri
    end

    def successor_uri
    end

  end
end
