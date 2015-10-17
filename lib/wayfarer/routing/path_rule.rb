require "mustermann"

module Wayfarer
  module Routing
    class PathRule < Rule
      attr_reader :pattern

      def initialize(str, opts = {}, &proc)
        @pattern = Mustermann.new(
          str, type: Wayfarer.config.mustermann_type
        )
        super(opts, &proc)
      end

      def params(uri)
        @pattern.params(uri.path.to_s)
      end

      private

      def match!(uri)
        @pattern === uri.path
      end
    end
  end
end
