module Scrapespeare
  module Extraction
    class Matcher

      attr_reader :type
      attr_reader :expression

      def initialize(matcher_hash)
        @type = matcher_hash.keys.first
        @expression = matcher_hash.values.first
      end

      def match(doc_or_nodes)
        case @type
        when :css then doc_or_nodes.css(@expression)
        when :xpath then doc_or_nodes.xpath(@expression)
        else fail "Unknown selector type `#{@type}`"
        end
      end

    end
  end
end
