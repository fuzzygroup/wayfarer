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

        matching_sub_rules = @sub_rules.find_all { |rule| rule.matches?(uri) }

        matching_sub_rules.reduce(false) do |bool, rule|
          bool || rule.matches?(uri)
        end
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
