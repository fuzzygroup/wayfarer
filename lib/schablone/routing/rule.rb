module Schablone
  module Routing
    # @private
    #
    # A {Rule} matches URIs given certain conditions. It can contain multiple
    # child rules which, in return, can contain multiple child rules. Thus, it
    # serves both as 
    # * A set of __current__ URIs that are being processed
    # * A set of __staged__ URIs that shall be processed under certain conditions
    # * A set of __cached__ URIs that have been processed
    #
    # After initialization, all three sets are empty. Hence, {#current_uris},
    # {#staged_uris} and {#cached_uris} return an empty `Array`:
    # ```
    # navigator.current_uris # => []
    # navigator.staged_uris  # => []
    # navigator.cached_uris  # => []
    # ```
    # URIs get staged by calling {#stage}:
    # ```
    # navigator.stage(URI("http://example.com"))
    # navigator.staged_uris.count # => 1
    # ```
    # After staging URIs, calling {#cycle} will set all staged URIs as
    # current that suffice the following conditions:
    # 1. The URI is not included in the set of current URIs
    # 2. The URI is not included in the set of cached URIs
    # 3. The URI is not forbidden by {#router}
    #
    # Assume some URIs have been processed and staged and all staged URIs
    # suffice the above criteria:
    # ```
    # navigator.current_uris.count # => 5
    # navigator.staged_uris.count  # => 3
    # navigator.cached_uris.count  # => 0
    #
    # navigator.cycle
    #
    # navigator.current_uris.count # => 3
    # navigator.staged_uris.count  # => 0
    # navigator.cached_uris.count  # => 5
    # ```
    # Because {#cached_uris} is backed by a {URISet}, both fragment identifiers
    # and trailing slashes are disregarded:
    # ```
    # navigator.stage(URI("http://example.com"))
    # navigator.stage(URI("http://example.com/"))
    # navigator.stage(URI("http://example.com#fragment-identifier"))
    #
    # navigator.staged_uris.count # => 1
    # ```
    # @param router [Schablone::Router]
    class Rule
      attr_reader :sub_rules

      def initialize(opts = {}, &proc)
        @sub_rules = []
        append_sub_rule_from_options(opts) unless opts.empty?
        instance_eval(&proc) if block_given?
      end

      # Sets staged URIs as current and clears the set of staged URIs
      #
      # @param [URI] URI to be cached staged
      # @return [true, false] whether the URI matched the {Rule}
      # @see #filter_staged_uris
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

      def append_sub_rule(other)
        @sub_rules << other; other
      end

      def append_sub_rule_from_options(opts)
        opts.inject(self) { |rule, (key, val)| rule.send(key, val) }
      end

      def match(*)
        @sub_rules.any?
      end
    end
  end
end
