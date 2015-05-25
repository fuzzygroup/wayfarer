module Schablone
  module Extraction
    class Extractor
      include Extractable

      attr_reader :matcher
      attr_reader :target_attrs

      def initialize(key, matcher_hash, *target_attrs, &proc)
        @key = key
        @matcher = Matcher.new(matcher_hash)
        @target_attrs = target_attrs
        @evaluator = Evaluator

        instance_eval(&proc) if block_given?
      end

      def extract(nodes)
        matched_nodes = matcher.match(nodes)

        if extractables.empty?
          extract = @evaluator.evaluate(matched_nodes, *@target_attrs)
        else
          extract = matched_nodes.map do |node|
            extractables.reduce({}) do |hash, extractable|
              hash.merge(extractable.extract(node))
            end
          end
        end

        { key => extract }
      end
    end
  end
end
