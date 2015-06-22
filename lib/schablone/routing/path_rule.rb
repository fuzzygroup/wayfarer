module Schablone
  module Routing
    class PathRule < Rule
      attr_reader :pattern

      def initialize(str_or_regexp, opts = {}, &proc)
        @pattern = str_or_regexp
        super(opts, &proc)
      end

      private

      def match!(uri)
        case @pattern
        when String then @pattern == uri.path
        when Regexp then !!(@pattern =~ uri.path)
        end
      end
    end
  end
end
