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

      def group(*argv, &proc)
        extractables << ExtractableGroup.new(*argv, &proc)
      end

      def scope(*argv, &proc)
        extractables << Scoper.new(*argv, &proc)
      end
    end
  end
end
