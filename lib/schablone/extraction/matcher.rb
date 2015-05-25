module Schablone
  module Extraction
    class Matcher
      attr_reader :type
      attr_reader :expression

      def initialize(matcher_hash)
        @type, @expression = matcher_hash.to_a.first
      end

      def match(doc_or_nodes)
        doc_or_nodes.send(@type, @expression)
      end
    end
  end
end
