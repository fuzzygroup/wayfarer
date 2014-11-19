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

      if extractables.empty?
        result = @evaluator.evaluate(matched_nodes, *@target_attributes)
      else
        result = matched_nodes.map do |node|
          extractables.reduce(Hash.new) do |hash, extractable|
            hash.merge(extractable.extract(node))
          end
        end
      end

      { @identifier => result }
    end

  end
end
