require "cgi"

module Scrapespeare
  module Routing
    class QueryRule

      def initialize(constraints)
        @constraints = constraints
      end

      def matches?(uri)
        query_params = CGI::parse(uri.query)
        query_params.none? { |field, vals| violates?(field, vals) }
      end

      private
      def violates?(field, vals)
        if constraint = @constraints[field.to_sym]
          violates_constraint?(constraint, vals)
        end
      end

      def violates_constraint?(constraint, vals)
        case constraint
        when Regexp then violates_regexp?(constraint, vals)
        when String then violates_string?(constraint, vals)
        end
      end

      def violates_regexp?(regexp, vals)
        vals.none? { |val| regexp === val }
      end

      def violates_string?(str, vals)
        vals.none? { |val| str == val }
      end

    end
  end
end
