module Scrapespeare
  class Scraper

    include Extractable

    # @param proc [Proc]
    def initialize(&proc)
      instance_eval(&proc) if block_given?
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
