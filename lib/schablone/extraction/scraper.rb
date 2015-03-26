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
        return @evaluator.call(doc) if @evaluator

        extractables.reduce(Hash.new) do |hash, extractable|
          hash.merge(extractable.extract(doc))
        end
      end

      alias_method :scrape, :extract

    end
  end
end
