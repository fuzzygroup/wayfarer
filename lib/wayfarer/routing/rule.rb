# frozen_string_literal: true
require "forwardable"

module Wayfarer
  module Routing
    # A tree in disguise.
    # @private
    class Rule
      include Enumerable
      extend Forwardable

      def_delegators :@child_rules, :each

      attr_reader :child_rules

      def initialize(opts = {}, &proc)
        @child_rules = []

        build_child_rule_chain_from_options(opts)
        instance_eval(&proc) if block_given?
      end

      def build_child_rule_chain_from_options(opts)
        opts.reduce(self) { |rule, (key, val)| rule.send(key, val) }
      end

      def matches?(uri)
        return false unless match!(uri)
        none? || any? { |child_rule| child_rule.matches?(uri) }
      end

      def invoke(uri)
        rule_chain = matching_rule_chain(uri)

        if rule_chain.any?
          [true, params_from_rule_chain(rule_chain, uri)]
        else
          false
        end
      end

      # rubocop:disable Lint/AssignmentInCondition
      def matching_rule_chain(uri, chain = [])
        if match!(uri) && none?
          chain << self
        elsif matching_child = detect { |child_rule| child_rule.matches?(uri) }
          matching_child.matching_rule_chain(uri, chain << self)
        else
          []
        end
      end
      # rubocop:enable Lint/AssignmentInCondition

      def params(*)
        {}
      end

      def uri(*argv, &proc)
        append_child_rule(URIRule.new(*argv, &proc))
      end

      def host(*argv, &proc)
        append_child_rule(HostRule.new(*argv, &proc))
      end

      def path(*argv, &proc)
        append_child_rule(PathRule.new(*argv, &proc))
      end

      def query(*argv, &proc)
        append_child_rule(QueryRule.new(*argv, &proc))
      end

      private

      def append_child_rule(other)
        @child_rules << other
        other
      end

      def match!(*)
        any?
      end

      def params_from_rule_chain(rule_chain, uri)
        rule_chain.reduce({}) { |hash, rule| hash.merge(rule.params(uri)) }
      end
    end
  end
end
