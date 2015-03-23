module Scrapespeare
  module Extraction
    class ExtractableGroup

      include Extractable

      def initialize(identifier, &proc)
        @identifier = identifier
        instance_eval(&proc) if block_given?
      end

      def extract(doc_or_nodes)
        if extractables.empty?
          result = ""
        else
          result = extractables.reduce(Hash.new) do |hash, extractable|
            hash.merge(extractable.extract(doc_or_nodes))
          end
        end

        { @identifier => result }
      end

    end
  end
end
