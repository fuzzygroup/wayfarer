# frozen_string_literal: true
require "forwardable"

module Wayfarer
  module Routing
    # A {Router} maps URIs onto a {Job}'s instance methods.
    class Router
      include Enumerable

      extend Forwardable

      # @!attribute [r] routes
      # @return [Array<Rule>]
      attr_reader :routes

      # @!attribute [r] blacklist
      # @return [Rule]
      attr_reader :blacklist

      Route = Struct.new(:method, :rule)

      def initialize(config)
        @config = config
        @routes = []
        @blacklist = Rule.new
      end

      # TODO Documentation
      delegate [:each] => :routes

      def draw(method, rule_opts = {}, &proc)
        @routes << Route.new(method, Rule.new(rule_opts, &proc))
      end

      # Returns the associated instance method of the first rule that matches a
      # URI and the collected parameter hash from the rule chain.
      # @return [[Symbol, Hash]] if a matching rule exists.
      # @return [false] if no matching rule exists or the URI is forbidden.
      def route(uri)
        return false if forbids?(uri)

        @routes.each do |route|
          is_matching, params = route.rule.invoke(uri)
          return route.method, params if is_matching && params
        end

        false
      end

      # Adds a {Rule} to the blacklist.
      def forbid(opts = {}, &proc)
        @blacklist.build_child_rule_chain_from_options(opts)
        @blacklist.instance_eval(&proc) if block_given?
        @blacklist
      end

      # Whether the URI is matched by the blacklist rule.
      # @see #forbid
      def forbids?(uri)
        @blacklist.matches?(uri)
      end

      # Whether the URI is allowed.
      # @see #forbid
      def allows?(uri)
        !forbids?(uri)
      end
    end
  end
end
