module Schablone
  module Routing
    class Router
      attr_reader :routes
      attr_reader :scrapers

      def initialize
        @routes   = []
        @scrapers = Hash.new(false)
      end

      def route(uri)
        @routes.each do |rule, sym|
          is_matching, params = rule =~ uri
          return @scrapers[sym], params if is_matching && params
        end

        false
      end

      def register_scraper(sym, &proc)
        @scrapers[sym] = proc
      end

      def draw(sym, *argv, &proc)
        @routes << [Rule.new(argv, &proc), sym]
      end
    end
  end
end
