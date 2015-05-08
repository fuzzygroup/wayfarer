module Schablone
  module Routing
    class Router
      attr_reader :routes
      attr_reader :scrapers

      def initialize
        @routes   = []
        @scrapers = {}
      end

      def route(uri)
        matched_route = @routes.each do |(rule, sym)|
          is_matching, params = rule =~ uri
          return @scrapers[sym], params if is_matching && params
        end

        false
      end

      # Associate a scraper Proc with a Symbol
      def register_scraper(sym, obj = nil, &proc)
        @scrapers[sym] = obj || proc
      end

      # sadfsadf
      def draw(sym, *argv, &proc)
        @routes << [Rule.new(argv, &proc), sym]
      end
    end
  end
end
