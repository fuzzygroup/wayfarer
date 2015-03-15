module Scrapespeare
  module Routing
    class Rule

      attr_reader :sub_rules

      def initialize(&proc)
        @sub_rules = []
        instance_eval(&proc) if block_given?
      end

      def matches?(uri)
        match(uri) || @sub_rules.any? { |rule| rule.matches?(uri) }
      end

      def host(str_or_regexp)
        @sub_rules << HostRule.new(str_or_regexp)
      end

      alias_method :add_host_sub_rule, :host

      def path(pattern_str)
        @sub_rules << PathRule.new(pattern_str)
      end

      alias_method :add_path_sub_rule, :path

      def query(constraints)
        @sub_rules << QueryRule.new(constraints)
      end

      alias_method :add_query_sub_rule, :query

    end
  end
end
