module Scrapespeare
  module Extractable

    # @return [Symbol]
    attr_reader :identifier

    # @return [Scrapespeare::Evaluator, Proc]
    attr_accessor :evaluator

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
      self
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
      self
    end

    # Adds an `ExtractorGroup` to `@extractables` and sets its `options`
    #
    # @param identifier [Symbol]
    # @param proc [Proc]
    # @see #add_extractable
    def group(identifier, &proc)
      extractables << ExtractableGroup.new(identifier, &proc)
      self
    end

    # Adds a `Scoper` to `@extractables` and sets its `options`
    #
    # @param matcher_hash [Hash]
    # @param proc [Proc]
    # @see #add_extractable
    def scope(matcher_hash, &proc)
      extractables << Scoper.new(matcher_hash, &proc)
      self
    end

    def pass_evaluator(extractor_identifier, evaluator)
      @evaluator = evaluator if @identifier == extractor_identifier

      extractables.each do |extractable|
        extractable.pass_evaluator(extractor_identifier, evaluator)
      end
    end

  end
end
