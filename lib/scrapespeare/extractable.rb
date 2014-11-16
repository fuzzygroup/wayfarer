module Scrapespeare
  module Extractable

    def extractors
      @extractors ||= []
    end

  private

    def add_extractor(identifier, matcher, *target_attributes, &proc)
      extractor = Scrapespeare::Extractor.new(
        identifier, matcher, *target_attributes, &proc
      )

      extractor.set(@options)

      extractors << extractor
    end

  end
end
