module Scrapespeare
  class Extractor

    include Extractable

    # @return [Symbol]
    attr_reader :identifier

    # @return [Matcher]
    attr_reader :matcher

    # @return [Array<String>]
    attr_reader :target_attrs

    # @param identifier [Symbol]
    # @param matcher_hash [Hash]
    # @param target_attributes [Array<String>]
    # @param proc [Proc]
    def initialize(identifier, matcher_hash, *target_attrs, &proc)
      @identifier = identifier
      @matcher = Scrapespeare::Matcher.new(matcher_hash)
      @target_attrs = target_attrs

      instance_eval(&proc) if block_given?
    end

    # TODO Documentation
    #
    # @param doc_or_nodes [#css, #xpath]
    # @return [Hash]
    def extract(doc_or_nodes)
      matched_nodes = @matcher.match(doc_or_nodes)

      if extractables.empty?
        result = Evaluator.evaluate(matched_nodes, *@target_attrs)
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
