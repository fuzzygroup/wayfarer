module Schablone
  module Routing
    class Router
      attr_reader :whitelist
      attr_reader :blacklist
      attr_reader :routes

      def initialize(scraper_table)
        @scraper_table = scraper_table

        @whitelist = Rule.new
        @blacklist = Rule.new

        @routes = {}
      end

      def allow(&proc)
        block_given? ? @whitelist.instance_eval(&proc) : @whitelist
      end

      def forbid(&proc)
        block_given? ? @blacklist.instance_eval(&proc) : @blacklist
      end

      def allows?(uri)
        !(@blacklist === uri) && @whitelist === uri
      end

      def forbids?(uri)
        !allows?(uri)
      end

      def map(scraper_sym, &proc)
        @routes[scraper_sym] = Rule.new(&proc)
      end

      def invoke(uri)
        detected_route = @routes.detect { |_, rule| rule === uri }
        @scraper_table[detected_route.first] if detected_route
      end
    end
  end
end
