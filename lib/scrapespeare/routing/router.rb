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

      def invoke(uri)
        return nil unless recognized?(uri)
        matching_route = @routes.detect { |route| route.matches?(uri) }
        matching_route.scraper_sym
      end

      private
      def recognized?(uri)
        @routes.any? { |route| route.matches?(uri) }
      end

    end
  end
end
