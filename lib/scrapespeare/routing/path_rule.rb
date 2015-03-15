require "mustermann"

module Scrapespeare
  module Routing
    class PathRule < Rule

      def initialize(pattern_str, &proc)
        @pattern = Mustermann.new(pattern_str, type: :template)
        super(&proc)
      end

      def matches?(uri)
        @pattern === uri.path
      end

    end
  end
end
