module Schablone
  module Extraction
    module Extractable
      attr_reader :key
      attr_accessor :evaluator

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

      def group(key, &proc)
        extractables << ExtractableGroup.new(key, &proc)
      end

      def scope(matcher_hash, &proc)
        extractables << Scoper.new(matcher_hash, &proc)
      end
    end
  end
end
