module Schablone
  module Extraction
    class Scraper

      include Extractable

      def initialize(&proc)
        if block_given?
          proc.arity == 1 ? (@evaluator = proc) : instance_eval(&proc)
        end
      end

      def extract(doc)
        result = extractables.reduce(Hash.new) do |hash, extractable|
          hash.merge(extractable.extract(doc))
        end

        result.taint
      end

      alias_method :scrape, :extract

    end
  end
end
