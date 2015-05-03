module Schablone
  module Routing
    # @abstract Concrete subclasses shall override {#match}
    #
    # @see URIRule
    # @see HostRule
    # @see PathRule
    # @see QueryRule
    #
    # A {Rule} matches URIs. It can contain multiple
    # child rules which, in return, can contain multiple child rules. Thus, it
    # serves both as a tree root and a node.
    #
    # A URI will be matched by {#===} given the following conditions:
    # 1. {#match} returns `true`
    # 2. __If__ the rule has child rules, at least one of them must match the URI
    #
    # This algorithm applies recursively. Suppose the following rule tree:
    # ```plain
    # + Rule A
    # |
    # +--+ HostRule B "example.com"
    # |
    # +--+ HostRule C "google.com"
    #    |
    #    +--+ PathRule D "/foo"
    #    |
    #    +--+ QueryRule E { qux: 42 }
    # ```
    # The root rule A will match the following URIs:
    # * `http://example.com` (A, B match)
    # * `http://google.com` (A, C match)
    # * `http://google.com/foo` (A, C, D match)
    # * `http://google.com?qux=42` (A, C, E match)
    #
    # In return, the following URIs will not be matched:
    # * `http://google.com/bar` (A, C match, but neither D nor E match)
    # * `http://google.com?qux=96` (A, C match, but neither D nor E match)
    #
    # @example
    #   rule_tree = Rule.new do
    #     host "example.com"
    #     host "google.com" do
    #       path "/foo"
    #       query qux: 42
    #     end
    #   end
    #
    #   rule_tree === URI("http://example.com")    # => true
    #   rule_tree === URI("http://google.com/bar") # => false
    class Rule
      # @!attribute [r] sub_rules
      attr_reader :sub_rules

      # Initializes a new {Rule}
      #
      # @example Initialization with a child HostRule
      #   Rule.new(host: "example.com")
      #
      # @example Initialization with multiple child PathRules
      #   Rule.new(paths: "/foo", "/bar")
      #
      # @example Initialization with a child HostRule and child PathRule
      #   Rule.new(host: "example.com", path: "/foo")
      #
      # @param [Hash] opts child rule literals to append
      # @option opts [String] :uri URI String passed to {URIRule#initialize}
      # @option opts [String] :uris URI Strings passed to {URIRule#initialize}
      # @option opts [String, Regexp] :host Host String or Regexp passed to {HostRule#initialize}
      # @option opts [String, Regexp] :hosts Host Strings or Regexps passed to {HostRule#initialize}
      # @option opts [String] :path Path String passed to {PathRule#initialize}
      # @option opts [String] :paths Path Strings passed to {PathRule#initialize}
      # @option opts [Hash] :query Query constraints passed to {QueryRule#initialize}
      # @option opts [Hash] :queries Query constraints passed to {QueryRule#initialize}
      #
      # @return [Navigator] the initialized {Navigator}
      def initialize(opts = {}, &proc)
        @sub_rules = []
        append_sub_rule_from_options(opts) unless opts.empty?
        instance_eval(&proc) if block_given?
      end

      # Checks whether the rule matches the URI
      #
      # @param [URI] uri URI to be matched
      # @return [true, false] whether the rule matched the URI
      # @see #match
      def ===(uri)
        return false unless matched = match(uri)
        return matched if @sub_rules.empty?
        @sub_rules.inject(false) { |bool, rule| bool || rule === uri }
      end

      def append_uri_sub_rule(uri_str, opts = {}, &proc)
        append_sub_rule(URIRule.new(uri_str, opts, &proc))
      end

      alias_method :uri, :append_uri_sub_rule
      alias_method :uris, :append_uri_sub_rule

      def append_host_sub_rule(str_or_regexp, opts = {}, &proc)
        append_sub_rule(HostRule.new(str_or_regexp, opts, &proc))
      end

      alias_method :host, :append_host_sub_rule
      alias_method :hosts, :append_host_sub_rule

      def append_path_sub_rule(pattern_str, opts = {}, &proc)
        append_sub_rule(PathRule.new(pattern_str, opts, &proc))
      end

      alias_method :path, :append_path_sub_rule
      alias_method :paths, :append_path_sub_rule

      def append_query_sub_rule(constraints, opts = {}, &proc)
        append_sub_rule(QueryRule.new(constraints, opts, &proc))
      end

      alias_method :query, :append_query_sub_rule
      alias_method :queries, :append_query_sub_rule

      private

      # Adds a child {Rule}
      #
      # @param other [Rule]
      # @return [Rule] the added {Rule}
      def append_sub_rule(other)
        @sub_rules << other; other
      end

      # Adds chained child rules from a Hash
      #
      # @param opts [Hash]
      # @return [Rule] the leaf rule
      def append_sub_rule_from_options(opts)
        opts.inject(self) { |rule, (key, val)| rule.send(key, val) }
      end

      # Checks whether any child rules are present
      #
      # @param uri [URI]
      # @return [true, false] whether any child rules are present
      def match(*)
        @sub_rules.any?
      end
    end
  end
end
