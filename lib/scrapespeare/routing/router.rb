module Scrapespeare
  module Routing
    class Router

      attr_reader :whitelist
      attr_reader :blacklist

      def initialize
        @whitelist = Rule.new
        @blacklist = Rule.new
      end

      def allow(&proc)
        block_given? ? @whitelist.instance_eval(&proc) : @whitelist
      end

      def forbid(&proc)
        block_given? ? @blacklist.instance_eval(&proc) : @blacklist
      end

      def allows?(uri)
        !@blacklist.applies_to?(uri) and @whitelist.applies_to?(uri)
      end

      def forbids?(uri)
        !allows?(uri)
      end

    end
  end
end
