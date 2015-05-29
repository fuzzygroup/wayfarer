module Schablone
  module Routing
    class Router
      attr_reader :routes
      attr_reader :blacklist

      Route = Struct.new(:method, :rule)

      def initialize
        @routes    = []
        @blacklist = Rule.new
      end

      def draw(method, rule_opts = {}, &proc)
        @routes << Route.new(method, Rule.new(rule_opts, &proc))
      end

      def route(uri)
        @routes.each do |route|
          is_matching, params = route.rule =~ uri
          return route.method, params if is_matching && params
        end

        false
      end

      def forbid(opts = {}, &proc)
        @blacklist.build_child_rule_chain_from_options(opts)
        @blacklist.instance_eval(&proc) if block_given?
        @blacklist
      end

      def forbids?(uri)
        @blacklist === uri
      end

      def allows?(uri)
        !forbids?(uri)
      end
    end
  end
end
