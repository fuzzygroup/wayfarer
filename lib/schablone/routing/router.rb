module Schablone
  module Routing
    class Router
      attr_reader :routes
      attr_reader :blacklist
      attr_reader :payloads

      Route = Struct.new(:sym, :rule)

      def initialize
        @routes    = []
        @blacklist = Rule.new
        @payloads  = Hash.new(false)
      end

      def route(uri)
        @routes.each do |route|
          is_matching, params = route.rule =~ uri
          payload = @payloads[route.sym]
          return payload, params if is_matching && params && payload
        end

        false
      end

      def forbid(opts = {}, &proc)
        @blacklist.build_child_rule_chain_from_options(opts)
        @blacklist.instance_eval(&proc) if block_given?
      end

      def forbids?(uri)
        @blacklist === uri
      end

      def allows?(uri)
        !forbids?(uri)
      end

      def register_payload(sym, &proc)
        @payloads[sym] = proc
      end

      def draw(sym, rule_opts = {}, &proc)
        @routes << Route.new(sym, Rule.new(rule_opts, &proc))
      end
    end
  end
end
