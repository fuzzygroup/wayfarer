module Scrapespeare
  module Routing
    class Rule

      attr_reader :sub_rules

      def initialize(&proc)
        @sub_rules = []
        instance_eval(&proc) if block_given?
      end

      def matches?(uri)
        false
      end

      def host(str_or_regexp)
        @sub_rules << HostRule.new(str_or_regexp)
      end

      def query(constraints)
        @sub_rules << QueryRule.new(constraints)
      end

    end
  end
end
