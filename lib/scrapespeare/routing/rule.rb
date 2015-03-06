require "mustermann"

module Scrapespeare
  module Routing
    class Rule

      def initialize(allowed, pattern_str)
        @allowed = allowed
        @pattern = Mustermann.new(pattern_str, type: :template)
      end

      def allowed?
        !!@allowed
      end

      def ===(uri)
        @pattern === uri.to_s
      end

    end
  end
end
