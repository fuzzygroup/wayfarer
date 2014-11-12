module Scrapespeare
  class Extractor

    include Scrapespeare::Configurable

    # @return [Symbol]
    attr_reader :identifier

    # @return [String]
    attr_reader :selector

    # @return [Array<Scrapespeare::Extractor>]
    attr_reader :nested_extractors

    # @param identifier [Symbol]
    # @param selector [String]
    # @param options [Hash]
    # @param proc [Proc]
    def initialize(identifier, selector, options = {}, &proc)
      @identifier, @selector = identifier, selector

      set(options)

      @nested_extractors = []

      instance_eval(&proc) if block_given?
    end

    # Initializes and adds an Extractor to {#nested_extractors}
    # @see #initialize
    def add_nested_extractor(identifier, selector, options = {})
      @nested_extractors << self.class.new(identifier, selector, options)
    end

    # Recursively builds up a result Hash by evaluating its and all {#nested_extractors}s' matched Elements
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

    # Returns the Elements matched by <pre>@selector</pre>
    #
    # @param document_or_nodes [#css]
    # @return [Nokogiri::XML::NodeSet]
    def query(document_or_nodes)
      document_or_nodes.css(@selector)
    end

    # Evaluates a NodeSet to an unpredictable value
    #
    # @param nodes [Nokogiri::XML::NodeSet]
    # @see Scrapespeare::Evaluator.evaluate
    def evaluate(nodes)
      Scrapespeare::Evaluator.evaluate(nodes)
    end

    # Initializes and adds a nested Extractor by calling {#add_nested_extractor}
    #
    # @param identifier [Symbol]
    # @param selector [Symbol]
    # @param attributes [Array<String>]
    # @param proc [Proc]
    # @see #add_nested_extractor
    def method_missing(identifier, selector, *attributes, &proc)
      add_nested_extractor(identifier, selector, &proc)
    end

  end
end
