module Schablone
  module Routing
    class PathRule < Rule
      attr_reader :pattern

      def initialize(str, opts = {}, &proc)
        @pattern = if defined?(Mustermann)
          Mustermann.new(str, type: :template)
        else
          str
        end

        super(opts, &proc)
      end

      def params(uri)
        defined?(Mustermann) ? @pattern.params(uri.path.to_s) : super
      end

      def match!(uri)
        defined?(Mustermann) ? @pattern === uri.path : @pattern == uri.to_s
      end
    end
  end
end
