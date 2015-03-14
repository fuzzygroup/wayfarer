module Scrapespeare
  module Routing
    class Router

      attr_reader :routes

      def initialize
        @routes = []
      end

      def register(pattern_str, scraper_sym = :default)
        @routes << (route = Route.new(pattern_str, scraper_sym))
        route
      end

      def invoke(uri)
        return nil unless recognizes?(uri)
        @routes.detect { |route| route.matches?(uri) }.invoke
      end

      def recognizes?(uri)
        @routes.any? { |route| route.matches?(uri) }
      end

    end
  end
end
