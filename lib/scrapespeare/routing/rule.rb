module Scrapespeare
  module Routing
    class Rule

      attr_reader :sub_rules

      def initialize(opts = {}, &proc)
        @sub_rules = []
        add_sub_rules_from_options(opts)
        instance_eval(&proc) if block_given?
      end

      def matches?(uri)
        return false unless apply(uri)
        return apply(uri) if @sub_rules.empty?
        @sub_rules.reduce(false) { |bool, rule| bool || rule.matches?(uri) }
      end

      def apply(uri)
        @sub_rules.any?
      end

      def add_host_sub_rule(str_or_regexp, opts = {}, &proc)
        @sub_rules << HostRule.new(str_or_regexp, opts, &proc)
      end

      alias_method :host, :add_host_sub_rule

      def add_path_sub_rule(pattern_str, opts = {}, &proc)
        @sub_rules << PathRule.new(pattern_str, opts, &proc)
      end

      alias_method :path, :add_path_sub_rule

      def add_query_sub_rule(constraints, opts = {}, &proc)
        @sub_rules << QueryRule.new(constraints, opts, &proc)
      end

      alias_method :query, :add_query_sub_rule

      private
      def add_sub_rules_from_options(opts)
        host(opts[:host])   if opts[:host]
        path(opts[:path])   if opts[:path]
        query(opts[:query]) if opts[:query]
      end

    end
  end
end
