module Schablone
  module Routing
    class Route

      def initialize(handler, rule, adapter = nil)
        @handler = handler
        @rule = rule
      end

      def ===(uri)
        @rule === uri
      end

    end
  end
end
