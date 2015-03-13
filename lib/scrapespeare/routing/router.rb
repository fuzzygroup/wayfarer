module Scrapespeare
  module Routing
    class Router

      attr_reader :routes

      def initialize
        @routes = []
      end

      def register(pattern_str, scraper_sym)
        @routes << (route = Route.new(pattern_str, scraper_sym))
        route
      end

    end
  end
end
