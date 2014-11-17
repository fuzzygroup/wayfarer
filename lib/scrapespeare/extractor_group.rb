module Scrapespeare
  class ExtractorGroup

    attr_reader :identifier

    def initialize(identifier, &proc)
      @identifier = identifier
      instance_eval(&proc) if block_given?
    end

  end
end
