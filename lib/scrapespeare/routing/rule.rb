module Scrapespeare
  module Routing
    class Rule

      attr_reader :sub_rules

      def initialize(opts = {}, &proc)
        @sub_rules = []
        append_sub_rule_from_options(opts) unless opts.empty?
        instance_eval(&proc) if block_given?
      end

      def applies_to?(uri)
        return false unless apply(uri)
        return apply(uri) if @sub_rules.empty?
        @sub_rules.inject(false) { |bool, rule| bool || rule.applies_to?(uri) }
      end

      def append_uri_sub_rule(uri_str, opts = {}, &proc)
        append_sub_rule(URIRule.new(uri_str, opts, &proc))
      end

      alias_method :uri, :append_uri_sub_rule

      def append_host_sub_rule(str_or_regexp, opts = {}, &proc)
        append_sub_rule(HostRule.new(str_or_regexp, opts, &proc))
      end

      alias_method :host, :append_host_sub_rule

      def append_path_sub_rule(pattern_str, opts = {}, &proc)
        append_sub_rule(PathRule.new(pattern_str, opts, &proc))
      end

      alias_method :path, :append_path_sub_rule

      def append_query_sub_rule(constraints, opts = {}, &proc)
        append_sub_rule(QueryRule.new(constraints, opts, &proc))
      end

      alias_method :query, :append_query_sub_rule

      def append_sub_rule(other)
        @sub_rules << other and other
      end

      alias_method :<<, :append_sub_rule

      private
      def append_sub_rule_from_options(opts)
        opts.reject! { |key, _ | not [:host, :path, :query].include?(key) }

        opts.inject(self) do |rule, (key, val)|
          case key
          when :host  then rule.append_host_sub_rule(val)
          when :path  then rule.append_path_sub_rule(val)
          when :query then rule.append_query_sub_rule(val)
          end
        end
      end

      def apply(uri)
        @sub_rules.any?
      end

    end
  end
end
