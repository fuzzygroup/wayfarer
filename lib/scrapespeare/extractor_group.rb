module Scrapespeare
  class ExtractorGroup

    include Extractable
    include Configurable

    attr_reader :identifier

    def initialize(identifier, &proc)
      @identifier = identifier
      instance_eval(&proc) if block_given?
    end

    def extract
      if extractors.empty?
        result = ""
      else
        result = extractors.reduce(Hash.new) do |hash, extractor|
          hash.merge(extractor.extract)
        end
      end

      { @identifier => result }
    end

  end
end
