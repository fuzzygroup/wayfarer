module Scrapespeare
  class Scraper

    include Extractable

    # @param proc [Proc]
    def initialize(&proc)
      instance_eval(&proc) if block_given?
    end

    # Reduces its {#extractors} returned extracts to a Hash
    #
    # @param (see #fetch)
    # @return [Hash]
    # @see Scrapespeare::Extractor#extract
    def extract(parsed_document)
      result = extractables.reduce(Hash.new) do |hash, extractable|
        hash.merge(extractable.extract(parsed_document))
      end

      result.taint
    end

    # alias_method :scrape, :extract

  end
end
