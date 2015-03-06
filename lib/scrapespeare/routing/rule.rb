require "mustermann"

module Scrapespeare
  module Routing
    class Rule

      def initialize(pattern_str)
        @pattern = Mustermann.new(pattern_str, type: :template)
      end

      def ===(uri)
        @pattern === uri.path
      end

    end
  end
end
