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

    end
  end
end
