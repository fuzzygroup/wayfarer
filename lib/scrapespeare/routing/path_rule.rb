require "mustermann"

module Scrapespeare
  module Routing
    class PathRule < Rule

      def initialize(pattern_str, opts = {}, &proc)
        @pattern = Mustermann.new(pattern_str, type: :template)
        super(opts, &proc)
      end

      private
      def apply(uri)
        @pattern === uri.path
      end

      def concatenated_path(path)
      end

    end
  end
end
