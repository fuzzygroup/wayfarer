module Schablone
  module Extraction
    class Scoper

      include Extractable

      attr_reader :matcher

      def initialize(matcher_hash, &proc)
        @matcher = Matcher.new(matcher_hash)

        instance_eval(&proc) if block_given?
      end

      def extract(doc_or_nodes)
        matched_nodes = matcher.match(doc_or_nodes)

        if extractables.empty?
          {}
        else
          extractables.reduce({}) do |hash, extractable|
            hash.merge(extractable.extract(matched_nodes))
          end
        end
      end

    end
  end
end
