module Schablone
  module Extraction
    module Extractable
      attr_reader :key

      def extractables
        @extractables ||= []
      end

      def css(key, selector, *target_attrs, &proc)
        extractables << Extractor.new(
          key, { css: selector }, *target_attrs, &proc
        )
      end

      def xpath(key, expression, *target_attrs, &proc)
        extractables << Extractor.new(
          key, { xpath: expression }, *target_attrs, &proc
        )
      end

      def group(*argv)
        extractables << ExtractableGroup.new(*argv)
      end

      def scope(*argv)
        extractables << Scoper.new(*argv)
      end
    end
  end
end
