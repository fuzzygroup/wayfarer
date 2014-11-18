module Scrapespeare
  module Extractable

    def extractables
      @extractables ||= []
    end

    def add_extractable(extractable)
      extractable.set(@options)
      extractables << extractable
    end

    def css(identifier, selector, *target_attributes, &proc)
      extractor = Extractor.new(
        identifier, { css: selector },*target_attributes, &proc
      )
      add_extractable(extractor)
    end

    def xpath(identifier, expression, *target_attributes, &proc)
      extractor = Extractor.new(
        identifier, { xpath: expression },*target_attributes, &proc
      )
      add_extractable(extractor)
    end

    def group(identifier, &proc)
      extractor_group = ExtractorGroup.new(identifier, &proc)
      add_extractable(extractor_group)
    end

    def scope(matcher, &proc)
      scoper = Scoper.new(matcher, &proc)
      add_extractable(scoper)
    end

  end
end
