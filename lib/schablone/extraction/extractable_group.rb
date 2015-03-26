module Schablone
  module Extraction
    class ExtractableGroup
      include Extractable

      def initialize(key, &proc)
        @key = key
        instance_eval(&proc) if block_given?
      end

      def extract(nodes)
        if extractables.empty?
          result = ""
        else
          result = extractables.reduce({}) do |hash, extractable|
            hash.merge(extractable.extract(nodes))
          end
        end

        { key => result }
      end
    end
  end
end
