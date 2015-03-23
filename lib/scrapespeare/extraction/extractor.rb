module Scrapespeare
  module Extraction
    class Extractor

      include Extractable

      attr_reader :matcher
      attr_reader :target_attrs

      def initialize(identifier, matcher_hash, *target_attrs, &proc)
        @identifier = identifier
        @matcher = Matcher.new(matcher_hash)
        @target_attrs = target_attrs
        @evaluator = Evaluator

        instance_eval(&proc) if block_given?
      end

      def extract(doc_or_nodes)
        matched_nodes = @matcher.match(doc_or_nodes)

        if extractables.empty?
          result = evaluate(matched_nodes, *@target_attrs)
        else
          result = matched_nodes.map do |node|
            extractables.reduce({}) do |hash, extractable|
              hash.merge(extractable.extract(node))
            end
          end
        end

        { @identifier => result }
      end

      private
      def evaluate(matched_nodes, *target_attrs)
        if @evaluator.is_a?(Proc)
          @evaluator.call(matched_nodes, *target_attrs)
        else
          @evaluator.evaluate(matched_nodes, *target_attrs)
        end
      end

    end
  end
end
