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
        return false unless match(uri)
        return match(uri) if @sub_rules.empty?
        @sub_rules.reduce(false) { |bool, rule| bool || rule.matches?(uri) }
      end

      def match(uri)
        true
      end

      def host(str_or_regexp, opts = {}, &proc)
        @sub_rules << HostRule.new(str_or_regexp, opts, &proc)
      end

      def path(pattern_str, opts = {}, &proc)
        @sub_rules << PathRule.new(pattern_str, opts, &proc)
      end

      def query(constraints, opts = {}, &proc)
        @sub_rules << QueryRule.new(constraints, opts, &proc)
      end

      private
      def add_sub_rules_from_options(opts)
        host(opts[:host])   if opts[:host]
        path(opts[:path])   if opts[:path]
        query(opts[:query]) if opts[:query]
      end

    end
  end
end
