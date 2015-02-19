module Scrapespeare
  module Extractable

    # @return [Array<Extractable>]
    def extractables
      @extractables ||= []
    end

    # Adds an `Extractor` to `@extractables` and sets its `options`
    #
    # @param identifier [Symbol]
    # @param selector [String]
    # @param target_attributes [Array<String>]
    # @param proc [Proc]
    # @see #add_extractable
    def css(identifier, selector, *target_attributes, &proc)
      extractables << Extractor.new(
        identifier, { css: selector }, *target_attributes, &proc
      )
    end

    # Adds an `Extractor` to `@extractables` and sets its `options`
    #
    # @param identifier [Symbol]
    # @param expression [String]
    # @param target_attributes [Array<String>]
    # @param proc [Proc]
    # @see #add_extractable
    def xpath(identifier, expression, *target_attributes, &proc)
      extractables << Extractor.new(
        identifier, { xpath: expression }, *target_attributes, &proc
      )
    end

    # Adds an `ExtractorGroup` to `@extractables` and sets its `options`
    #
    # @param identifier [Symbol]
    # @param proc [Proc]
    # @see #add_extractable
    def group(identifier, &proc)
      extractables << ExtractableGroup.new(identifier, &proc)
    end

    # Adds a `Scoper` to `@extractables` and sets its `options`
    #
    # @param matcher [Hash]
    # @param proc [Proc]
    # @see #add_extractable
    def scope(matcher, &proc)
      extractables << Scoper.new(matcher, &proc)
    end

  end
end
