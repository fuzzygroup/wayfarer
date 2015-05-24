module Schablone
  module Routing
    class Rule
      include Enumerable

      attr_reader :path_offset
      attr_reader :child_rules

      def initialize(opts = {}, path_offset = "", &proc)
        @path_offset = path_offset
        @child_rules = []
        append_child_rule_from_options(opts) unless opts.empty?
        instance_eval(&proc) if block_given?
      end

      def each(&proc)
        child_rules.each(&proc)
      end

      def =~(uri)
        rule_chain = matching_rule_chain(uri)

        if rule_chain.any?
          [true, params_from_rule_chain(rule_chain, uri)]
        else
          false
        end
      end

      def matches?(uri)
        return false unless match(uri)
        leaf? || any? { |child_rule| child_rule.matches?(uri) }
      end

      alias_method :===, :matches?

      def matching_rule_chain(uri, chain = [])
        if matches?(uri) && leaf?
          chain << self
        elsif matching_child = first_matching_child(uri)
          matching_child.matching_rule_chain(uri, chain << self)
        else
          []
        end
      end

      def params_from_rule_chain(rule_chain, uri)
        rule_chain.inject({}) { |hash, rule| hash.merge(rule.params(uri)) }
      end

      def leaf?
        child_rules.empty?
      end

      def first_matching_child(uri)
        detect { |child_rule| child_rule.matches?(uri) }
      end

      def params(uri)
        respond_to?(:pattern) ? pattern.params(uri.path) : {}
      end

      def append_uri_sub_rule(uri_str, opts = {}, &proc)
        append_child_rule(URIRule.new(uri_str, opts, &proc))
      end

      alias_method :uri, :append_uri_sub_rule
      alias_method :uris, :append_uri_sub_rule

      def append_host_sub_rule(str_or_regexp, opts = {}, &proc)
        append_child_rule(HostRule.new(str_or_regexp, opts, &proc))
      end

      alias_method :host, :append_host_sub_rule
      alias_method :hosts, :append_host_sub_rule

      def append_path_sub_rule(pattern_str, opts = {}, &proc)
        append_child_rule(PathRule.new(pattern_str, opts, &proc))
      end

      alias_method :path, :append_path_sub_rule
      alias_method :paths, :append_path_sub_rule

      def append_query_sub_rule(constraints, opts = {}, &proc)
        append_child_rule(QueryRule.new(constraints, opts, &proc))
      end

      alias_method :query, :append_query_sub_rule
      alias_method :queries, :append_query_sub_rule

      def append_child_rule(other)
        @child_rules << other; other
      end

      def inspect
        "#{self.class}"
      end

      private

      def append_child_rule_from_options(opts)
        opts.inject(self) { |rule, (key, val)| rule.send(key, val) }
      end

      def match(*)
        @child_rules.any?
      end
    end
  end
end
