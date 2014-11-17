module Scrapespeare
  class Extractor

    include Scrapespeare::Configurable
    include Scrapespeare::Extractable

    # @!attribute [r] identifier
    #   @return [Symbol]
    attr_reader :identifier

    # @!attribute [r] matcher
    #   @return [Scrapespeare::Matcher]
    attr_reader :matcher

    # @!attribute [r] target_attributes
    #   @return [Array<String>]
    attr_reader :target_attributes

    # @param identifier [Symbol]
    # @param matcher [Hash]
    # @param target_attributes [Array<String>]
    # @param proc [Proc]
    def initialize(identifier, matcher, *target_attributes, &proc)
      @identifier = identifier
      @matcher = Scrapespeare::Matcher.new(matcher)
      @target_attributes = target_attributes
      @evaluator = Scrapespeare::Evaluator

      set(options)

      instance_eval(&proc) if block_given?
    end

    # Recursively builds up a result Hash by evaluating its and all {#nested_extractors}' matched Elements
    #
    # @param (see #query)
    def extract(document_or_nodes)
      matched_nodes = @matcher.match(document_or_nodes)

      unless extractors.any?
        result = evaluate(matched_nodes)
      else
        result = matched_nodes.map do |node|
          extractors.reduce(Hash.new) do |hash, extractor|
            hash.merge(extractor.extract(node))
          end
        end
      end

      { @identifier => result }
    end

  private

    # Delegates evaluation of a NodeSet by calling {Scrapespeare::Evaluator.evaluate} and passing `@target_attributes`
    #
    # @param nodes [Nokogiri::XML::NodeSet]
    # @see Scrapespeare::Evaluator.evaluate
    def evaluate(nodes)
      @evaluator.evaluate(nodes, *@target_attributes)
    end

  end
end
