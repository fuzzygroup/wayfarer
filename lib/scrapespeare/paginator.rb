module Scrapespeare
  class Paginator

    attr_accessor :history
    attr_reader   :halt_cause

    def initialize(scraper)
      @scraper      = scraper
      @http_adapter = HTTPAdapters::NetHTTPAdapter.new
      @history      = []
    end

    def paginate(uri)
      @halt_cause = catch :halt do
        current_uri = uri

        loop do
          update_history(current_uri)
          response_body = fetch(current_uri)
          doc = Parser.parse(response_body)
          yield @scraper.extract(doc)
          current_uri = next_uri(current_uri, doc)
        end
      end
    end

    private
    def halt(cause)
      throw :halt, cause
    end

    def fetch(uri)
      status_code, response_body, _ = @http_adapter.fetch(uri)

      if status_code > 299 # TODO Don't be THAT naive
        halt :followed_dead_link
      else
        response_body
      end
    end

    def update_history(uri)
      @history.include?(uri) ? (halt :uri_already_visited) : @history.push(uri)
    end

  end
end
