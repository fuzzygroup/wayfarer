module Schablone
  module Routing
    class PathRule < Rule
      attr_reader :pattern

      def initialize(str, opts = {}, &proc)
        @pattern = str
        super(opts, &proc)
      end

      private

      def match!(uri)
        uri.path == @pattern
      end
    end
  end
end
