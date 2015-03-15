require "mustermann"

module Scrapespeare
  module Routing
    class PathRule

      def initialize(pattern_str)
        @pattern = Mustermann.new(pattern_str, type: :template)
      end

      def matches?(uri)
        @pattern === uri.path
      end

    end
  end
end
