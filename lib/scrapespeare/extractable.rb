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

    def css(identifier, selector, *target_attributes, &proc)
      add_extractor(identifier, { css: selector }, target_attributes, &proc)
    end

    def xpath(identifier, expression, *target_attributes, &proc)
      add_extractor(identifier, { xpath: expression }, target_attributes, &proc)
    end

  end
end
