module Scrapespeare
  class ExtractorGroup

    include Extractable

    attr_reader :identifier

    def initialize(identifier, &proc)
      @identifier = identifier
      instance_eval(&proc) if block_given?
    end

    def extract
      if extractors.empty?
        result = ""
      end

      { @identifier => result }
    end

  end
end
