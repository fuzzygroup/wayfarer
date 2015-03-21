require "pry"

module Scrapespeare
  module Routing
    class Rule

      attr_reader :sub_rules

      def initialize(opts = {}, &proc)
        @sub_rules = []
        add_sub_rule_from_options(opts) unless opts.empty?
        instance_eval(&proc) if block_given?
      end

      def applies_to?(uri)
        return false unless apply(uri)
        return apply(uri) if @sub_rules.empty?
        @sub_rules.reduce(false) { |bool, rule| bool || rule.applies_to?(uri) }
      end

      def add_uri_sub_rule(uri_str, opts = {}, &proc)
        add_sub_rule(URIRule.new(uri_str, opts, &proc))
      end

      alias_method :uri, :add_uri_sub_rule

      def add_host_sub_rule(str_or_regexp, opts = {}, &proc)
        add_sub_rule(HostRule.new(str_or_regexp, opts, &proc))
      end

      alias_method :host, :add_host_sub_rule

      def add_path_sub_rule(pattern_str, opts = {}, &proc)
        add_sub_rule(PathRule.new(pattern_str, opts, &proc))
      end

      alias_method :path, :add_path_sub_rule

      def add_query_sub_rule(constraints, opts = {}, &proc)
        add_sub_rule(QueryRule.new(constraints, opts, &proc))
      end

      alias_method :query, :add_query_sub_rule

      def add_sub_rule(other)
        @sub_rules << other and other
      end

      alias_method :<<, :add_sub_rule

      private
      def add_sub_rule_from_options(opts)
        opts.reject! { |key, _ | not [:host, :path, :query].include?(key) }

        sub_rule = Rule.new
        opts.inject(sub_rule) do |rule, (key, val)|
          case key
          when :host  then rule.add_host_sub_rule(val)
          when :path  then rule.add_path_sub_rule(val)
          when :query then rule.add_query_sub_rule(val)
          end
        end

        add_sub_rule(sub_rule.sub_rules.first)
      end

      def apply(uri)
        @sub_rules.any?
      end

    end
  end
end
