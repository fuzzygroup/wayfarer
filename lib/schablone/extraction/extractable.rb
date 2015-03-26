module Schablone
  module Extraction
    module Extractable
      attr_reader :key
      attr_accessor :evaluator

      def extractables
        @extractables ||= []
      end

      def add_css_extractor(key, selector, *target_attrs, &proc)
        extractables << Extractor.new(
          key, { css: selector }, *target_attrs, &proc
        )
      end

      alias_method :css, :add_css_extractor

      def add_xpath_extractor(key, expression, *target_attrs, &proc)
        extractables << Extractor.new(
          key, { xpath: expression }, *target_attrs, &proc
        )
      end

      alias_method :xpath, :add_xpath_extractor

      def add_group(key, &proc)
        extractables << ExtractableGroup.new(key, &proc)
      end

      alias_method :group, :add_group

      def add_scoper(matcher_hash, &proc)
        extractables << Scoper.new(matcher_hash, &proc)
      end

      alias_method :scope, :add_scoper
    end
  end
end
