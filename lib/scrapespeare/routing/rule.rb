module Scrapespeare
  module Routing
    class Rule

      attr_reader :sub_rules

      def initialize(&proc)
        @sub_rules = []
        instance_eval(&proc) if block_given?
      end

      def matches?(uri)
        return false unless match(uri)
        return true if @sub_rules.empty?

        @sub_rules.reduce(false) { |bool, rule| bool || rule.matches?(uri) }
      end

      def match(uri)
        true
      end

      def host(str_or_regexp, &proc)
        @sub_rules << HostRule.new(str_or_regexp, &proc)
      end

      def path(pattern_str, &proc)
        @sub_rules << PathRule.new(pattern_str, &proc)
      end

      def query(constraints, &proc)
        @sub_rules << QueryRule.new(constraints, &proc)
      end

    end
  end
end
