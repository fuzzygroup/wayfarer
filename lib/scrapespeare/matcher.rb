module Scrapespeare
  class Matcher

    # @return [String]
    attr_reader :type

    # @return [String]
    attr_reader :expression

    # @param hash [Hash]
    def initialize(hash)
      @type = hash.keys.first
      @expression = hash.values.first
    end

    # Returns a set of elements matched by `@expression`
    #
    # If `@expression` is `:css`, `#css` is called for querying.
    # If `@expression` is `:xpath`, `#xpath` is called for querying
    #
    # @param document_or_nodes [#css, #xpath]
    # @return [Nokogiri::XML::NodeSet]
    # @raise [RuntimeError] if `@expression` is not `:css` or `:xpath`
    def match(document_or_nodes)
      case @type
      when :css
        document_or_nodes.css(@expression)
      when :xpath
        document_or_nodes.xpath(@expression)
      else
        fail "Unknown selector type `#{@type}`"
      end
    end

  end
end
