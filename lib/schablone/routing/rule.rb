module Schablone
  module Routing
    class Rule
      include Enumerable

      attr_reader :path_offset
      attr_reader :child_rules

      def initialize(opts = {}, path_offset = "", &proc)
        @path_offset = path_offset
        @child_rules = []

        build_child_rule_chain_from_options(opts)
        instance_eval(&proc) if block_given?
      end

      def each(&proc)
        child_rules.each(&proc)
      end

      def match!(*)
        any?
      end

      def match(uri)
        return false unless match!(uri)
        none? || any? { |child_rule| child_rule.match(uri) }
      end

      def matching_rule_chain(uri, chain = [])
        if match!(uri) && none?
          chain << self
        elsif matching_child = detect { |child_rule| child_rule.match(uri) }
          matching_child.matching_rule_chain(uri, chain << self)
        else
          []
        end
      end

      def =~(uri)
        rule_chain = matching_rule_chain(uri)

        if rule_chain.any?
          [true, params_from_rule_chain(rule_chain, uri)]
        else
          false
        end
      end

      alias_method :===, :match

      def params(uri)
        respond_to?(:pattern) ? pattern.params(uri.path) : {}
      end

      def params_from_rule_chain(rule_chain, uri)
        rule_chain.inject({}) { |hash, rule| hash.merge(rule.params(uri)) }
      end

      def uri(*argv)
        append_child_rule(URIRule.new(*argv))
      end

      def host(*argv)
        append_child_rule(HostRule.new(*argv))
      end

      def path(*argv)
        append_child_rule(PathRule.new(*argv))
      end

      def query(*argv)
        append_child_rule(QueryRule.new(*argv))
      end

      def append_child_rule(other)
        @child_rules << other; other
      end

      private

      def build_child_rule_chain_from_options(opts)
        opts.inject(self) { |rule, (key, val)| rule.send(key, val) }
      end
    end
  end
end
