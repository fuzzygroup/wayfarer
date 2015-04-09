module Schablone
  module Routing
    class Router
      attr_reader :whitelist
      attr_reader :blacklist
      attr_reader :routes

      def initialize
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

      def map(sym, &proc)
        sym = Rule.new.instance_eval(&proc)
      end
    end
  end
end
