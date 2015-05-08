module Schablone
  module Routing
    class Router
      attr_reader :routes
      attr_reader :handlers
      attr_reader :blacklist

      def initialize
        @handlers  = {}
        @routes    = {}
        @blacklist = Rule.new
      end

      def forbid(&proc)
        block_given? ? @blacklist.instance_eval(&proc) : @blacklist
      end

      def forbidden_by_robots?(uri)
        
      end

      def forbids?(uri)
        @blacklist === uri
      end

      def register_handler(sym, &proc)
        @handlers[sym] = proc
      end

      def map(sym, &proc)
        @routes[sym] = Rule.new(&proc)
      end

      def invoke(uri)
        if detected_route = @routes.detect { |_, rule| rule === uri }
          return sym = detected_route.first, @handlers[sym]
        end
      end
    end
  end
end
