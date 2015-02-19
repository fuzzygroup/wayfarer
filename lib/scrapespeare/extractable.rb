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
    # @param target_attrs [Array<Symbol>]
    # @param proc [Proc]
    # @see #add_extractable
    def css(identifier, selector, *target_attrs, &proc)
      extractables << Extractor.new(
        identifier, { css: selector }, *target_attrs, &proc
      )
    end

    # Adds an `Extractor` to `@extractables` and sets its `options`
    #
    # @param identifier [Symbol]
    # @param expression [String]
    # @param target_attrs [Array<Symbol>]
    # @param proc [Proc]
    # @see #add_extractable
    def xpath(identifier, expression, *target_attrs, &proc)
      extractables << Extractor.new(
        identifier, { xpath: expression }, *target_attrs, &proc
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
    # @param matcher_hash [Hash]
    # @param proc [Proc]
    # @see #add_extractable
    def scope(matcher_hash, &proc)
      extractables << Scoper.new(matcher_hash, &proc)
    end

  end
end
