module Scrapespeare
  module Routing
    class RuleSet

      attr_reader :rules

      def initialize
        @rules = []
      end

      def <<(rule)
        @rules << rule
      end

      def allowed?(uri)
        @rules.any? { |rule| rule === uri }
      end

    end
  end
end
