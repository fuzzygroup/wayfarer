module Scrapespeare
  class Scoper

    include Configurable
    include Extractable

    attr_reader :matcher

    def initialize(matcher, &proc)
      @matcher = Matcher.new(matcher)

      instance_eval(&proc) if block_given?
    end

    def extract(document_or_nodes)
      matched_nodes = @matcher.match(document_or_nodes)

      if extractors.empty?
        result = ""
      else
        result = extractors.reduce(Hash.new) do |hash, extractor|
          hash.merge(extractor.extract(matched_nodes))
        end
      end

      return result
    end

  end
end
