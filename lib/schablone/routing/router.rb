module Schablone
  module Routing
    class Router
      attr_reader :routes
      attr_reader :targets
      attr_reader :blacklist

      def initialize
        @targets   = {}
        @routes    = {}
        @blacklist = Rule.new
      end

      def forbid(&proc)
        block_given? ? @blacklist.instance_eval(&proc) : @blacklist
      end

      def forbids?(uri)
        @blacklist === uri
      end

      def register(sym, &proc)
        @targets[sym] = proc
      end

      def map(scraper_sym, &proc)
        @routes[scraper_sym] = Rule.new(&proc)
      end

      def invoke(uri)
        if detected_route = @routes.detect { |_, rule| rule === uri }
          @targets[detected_route.first]
        end
      end
    end
  end
end
