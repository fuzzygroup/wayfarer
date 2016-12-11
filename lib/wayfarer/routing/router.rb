# frozen_string_literal: true
module Wayfarer
  module Routing
    # A {Router} maps URIs onto a {Job}'s instance methods.
    class Router
      # @!attribute [r] routes
      # @return [Array<Rule>]
      attr_reader :routes

      # @!attribute [r] blacklist
      # @return [Rule]
      attr_reader :blacklist

      Route = Struct.new(:method, :rule)

      def initialize
        @routes = []
        @blacklist = Rule.new
      end

      # Adds a new route.
      # @see Rule#uri
      # @see Rule#host
      # @see Rule#path
      # @see Rule#query
      #
      # @example By accessing the {Job} class' singleton router directly
      #   class DummyJob < Wayfarer::Job
      #     route.draw :foo, uri: "https://example.com"
      #     route.draw :bar, uri: "https://w3c.org"
      #
      #     def foo; end
      #     def bar; end
      #   end
      #
      # @example By passing in a block
      #   class DummyJob < Wayfarer::Job
      #     routes do
      #       draw :foo, uri: "https://example.com"
      #       draw :bar, uri: "https://w3c.org"
      #     end
      #
      #     def foo; end
      #     def bar; end
      #   end
      #
      # @example By nesting blocks
      #   class DummyJob < Wayfarer::Job
      #     routes do
      #       draw :foo do
      #         uri "https://example.com"
      #       end
      #
      #       draw :bar do
      #         uri "https://w3c.org"
      #       end
      #     end
      #
      #     def foo; end
      #     def bar; end
      #   end
      def draw(method, rule_opts = {}, &proc)
        @routes << Route.new(method, Rule.new(rule_opts, &proc))
      end

      # Returns the associated instance method of the first {Rule} that matches
      # a URI and the collected parameter hash from the rule chain.
      # @return [[Symbol, Hash]] if a matching rule exists.
      # @return [false] if no matching rule exists or the URI is forbidden.
      def route(uri)
        return false if forbids?(uri)

        @routes.each do |route|
          is_matching, params = route.rule =~ uri
          return route.method, params if is_matching && params
        end

        false
      end

      # Adds a {Rule} to the blacklist.
      # @see #draw
      def forbid(opts = {}, &proc)
        @blacklist.build_child_rule_chain_from_options(opts)
        @blacklist.instance_eval(&proc) if block_given?
        @blacklist
      end

      # Whether the URI is matched by the blacklist {Rule}.
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
