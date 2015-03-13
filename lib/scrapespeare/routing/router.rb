module Scrapespeare
  module Routing
    class Router

      attr_reader :routes

      def initialize
        @routes = []
      end

      def register(pattern_str, scraper_sym)
        @routes << Route.new(pattern_str, scraper_sym)
      end

    end
  end
end
