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
        false
      end

    end
  end
end
