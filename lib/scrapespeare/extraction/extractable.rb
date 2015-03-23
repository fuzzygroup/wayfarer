module Scrapespeare
  module Extraction
    module Extractable

      attr_reader :identifier
      attr_accessor :evaluator

      def extractables
        @extractables ||= []
      end

      def css(identifier, selector, *target_attrs, &proc)
        extractables << Extractor.new(
          identifier, { css: selector }, *target_attrs, &proc
        )
      end

      def xpath(identifier, expression, *target_attrs, &proc)
        extractables << Extractor.new(
          identifier, { xpath: expression }, *target_attrs, &proc
        )
      end

      def group(identifier, &proc)
        extractables << ExtractableGroup.new(identifier, &proc)
      end

      def scope(matcher_hash, &proc)
        extractables << Scoper.new(matcher_hash, &proc)
      end

    end
  end
end
