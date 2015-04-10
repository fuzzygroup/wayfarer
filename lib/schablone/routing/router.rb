module Schablone
  module Routing
    class Router
      attr_reader :whitelist
      attr_reader :blacklist
      attr_reader :routes

      def initialize(scraper_table)
        @scraper_table = scraper_table
        @blacklist = Rule.new
        @routes = {}
      end

      def forbid(&proc)
        block_given? ? @blacklist.instance_eval(&proc) : @blacklist
      end

      def forbids?(uri)
        @blacklist === uri
      end

      def map(scraper_sym, &proc)
        @routes[scraper_sym] = Rule.new(&proc)
      end

      def invoke(uri)
        if detected_route = @routes.detect { |_, rule| rule === uri }
          @scraper_table[detected_route.first]
        end
      end
    end
  end
end
