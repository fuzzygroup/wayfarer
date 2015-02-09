module Scrapespeare
  class Scoper

    include Extractable

    # @return [Matcher]
    attr_reader :matcher

    # @param matcher [Hash]
    # @param proc [Proc]
    # @see Matcher#initialize
    def initialize(matcher, &proc)
      @matcher = Matcher.new(matcher)

      instance_eval(&proc) if block_given?
    end

    # Recursively returns a reduced Hash of the Hashes returned by calling `#extract` on all its `extractables`
    #
    # If no `extractables` are present, an empty Hash is returned
    #
    # @param document_or_nodes [#css, #xpath]
    # @return [Hash]
    def extract(document_or_nodes)
      matched_nodes = @matcher.match(document_or_nodes)

      if extractables.empty?
        return {}
      else
        return extractables.reduce(Hash.new) do |hash, extractable|
          hash.merge(extractable.extract(matched_nodes))
        end
      end
    end

  end
end
