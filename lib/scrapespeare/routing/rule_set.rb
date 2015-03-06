module Scrapespeare
  module Routing
    class RuleSet

      attr_reader :rules

      def initialize
        @rules = []
      end

      def <<(pattern_str)
        @rules << Rule.new(pattern_str)
      end

      def allowed?(uri)
        @rules.any? { |rule| rule === uri }
      end

    end
  end
end
