require "mustermann"

module Schablone
  module Routing
    class PathRule < Rule
      attr_reader :pattern

      def initialize(pattern_str, opts = {}, &proc)
        @pattern = Mustermann.new(pattern_str, type: :template)
        super(opts, &proc)
      end

      private

      def match(uri)
        @pattern === uri.path
      end
    end
  end
end
