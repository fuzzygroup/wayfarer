module Scrapespeare
  class Matcher

    attr_reader :type
    attr_reader :expression

    def initialize(hash)
      @type = hash.keys.first
      @expression = hash.values.first
    end

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
