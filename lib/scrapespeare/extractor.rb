module Scrapespeare
  class Extractor

    include Scrapespeare::Configurable

    # @!attribute [r] identifier
    #   @return [Symbol]
    attr_reader :identifier

    # @!attribute [r] matcher
    #   @return [Scrapespeare::Matcher]
    attr_reader :matcher

    # @!attribute [r] nested_extractors
    #   @return [Array<Scrapespeare::Extractor>]
    attr_reader :nested_extractors

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

      @nested_extractors = []
      @evaluator = Scrapespeare::Evaluator

      set(options)

      instance_eval(&proc) if block_given?
    end

    # Initializes and adds an Extractor to {#nested_extractors}
    #
    # @param (see #initialize)
    def add_nested_extractor(identifier, matcher, *target_attributes, &proc)
      nested_extractor = self.class.new(
        identifier, matcher, *target_attributes, &proc
      )

      nested_extractor.set(@options)

      @nested_extractors << nested_extractor
    end

    # Recursively builds up a result Hash by evaluating its and all {#nested_extractors}' matched Elements
    #
    # @param (see #query)
    def extract(document_or_nodes)
      matched_nodes = query(document_or_nodes)

      unless @nested_extractors.any?
        result = evaluate(matched_nodes)
      else
        result = matched_nodes.map do |node|
          @nested_extractors.reduce(Hash.new) do |hash, extractor|
            hash.merge(extractor.extract(node))
          end
        end
      end

      { @identifier => result }
    end

  private

    # Returns the Elements matched by `@selector`
    #
    # @param (see Scrapespeare::Matcher#match)
    # @return [Nokogiri::XML::NodeSet]
    def query(document_or_nodes)
      @matcher.match(document_or_nodes)
    end

    # Delegates evaluation of a NodeSet by calling {Scrapespeare::Evaluator.evaluate} and passing `@target_attributes`
    #
    # @param nodes [Nokogiri::XML::NodeSet]
    # @see Scrapespeare::Evaluator.evaluate
    def evaluate(nodes)
      @evaluator.evaluate(nodes, *@target_attributes)
    end

    # Initializes and adds a nested Extractor by calling {#add_nested_extractor}
    #
    # @param (see #add_nested_extractor)
    def method_missing(identifier, matcher, *target_attributes, &proc)
      add_nested_extractor(identifier, matcher, *target_attributes, &proc)
    end

  end
end
