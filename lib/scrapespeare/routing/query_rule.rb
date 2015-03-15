require "cgi"

module Scrapespeare
  module Routing
    class QueryRule < Rule

      def initialize(field_constraints, &proc)
        @field_constraints = field_constraints
        super(&proc)
      end

      def match(uri)
        CGI::parse(uri.query).none? { |field, vals| violates?(field, vals) }
      rescue NoMethodError
        # `CGI::parse` throws a NoMethodError if `uri.query` is an empty string.
        # TODO Test case
      end

      private
      def violates?(field, vals)
        if constraint = @field_constraints[field.to_sym]
          violates_constraint?(constraint, vals)
        end
      end

      def violates_constraint?(constraint, vals)
        case constraint
        when String  then violates_string?(constraint, vals)
        when Integer then violates_integer?(constraint, vals)
        when Regexp  then violates_regexp?(constraint, vals)
        when Range   then violates_range?(constraint, vals)
        end
      end

      def violates_string?(str, vals)
        vals.none? { |val| str == val }
      end

      def violates_integer?(int, vals)
        vals.none? { |val| int == Integer(val) }
      rescue ArgumentError
        # `String#to_i` returns `0` if its receiver can not be converted to a
        # valid number. Therefore `Kernel#Integer` is used, which throws an
        # `ArgumentError` instead
        true
      end

      def violates_regexp?(regexp, vals)
        vals.none? { |val| regexp === val }
      end

      def violates_range?(range, vals)
        vals.none? { |val| range.include?(val.to_i) }
      end

    end
  end
end
