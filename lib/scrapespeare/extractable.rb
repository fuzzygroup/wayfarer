module Scrapespeare
  module Extractable

    # @return [Array<Extractable>]
    def extractables
      @extractables ||= []
    end

    # Adds an `Extractable` to `@extractables` and sets its `options`
    #
    # @param extractable [Extractable]
    # @see Configurable#set
    def add_extractable(extractable)
      extractable.set(@options)
      extractables << extractable
    end

    # Adds an `Extractor` to `@extractables` and sets its `options`
    #
    # @param identifier [Symbol]
    # @param selector [String]
    # @param target_attributes [Array<String>]
    # @param proc [Proc]
    # @see #add_extractable
    def css(identifier, selector, *target_attributes, &proc)
      extractor = Extractor.new(
        identifier, { css: selector },*target_attributes, &proc
      )
      add_extractable(extractor)
    end

    # Adds an `Extractor` to `@extractables` and sets its `options`
    #
    # @param identifier [Symbol]
    # @param expression [String]
    # @param target_attributes [Array<String>]
    # @param proc [Proc]
    # @see #add_extractable
    def xpath(identifier, expression, *target_attributes, &proc)
      extractor = Extractor.new(
        identifier, { xpath: expression }, *target_attributes, &proc
      )
      add_extractable(extractor)
    end

    # Adds an `ExtractorGroup` to `@extractables` and sets its `options`
    #
    # @param identifier [Symbol]
    # @param proc [Proc]
    # @see #add_extractable
    def group(identifier, &proc)
      extractor_group = ExtractorGroup.new(identifier, &proc)
      add_extractable(extractor_group)
    end

    # Adds a `Scoper` to `@extractables` and sets its `options`
    #
    # @param matcher [Hash]
    # @param proc [Proc]
    # @see #add_extractable
    def scope(matcher, &proc)
      scoper = Scoper.new(matcher, &proc)
      add_extractable(scoper)
    end

  end
end
