module Scrapespeare
  class ExtractorGroup

    include Extractable
    include Configurable

    attr_reader :identifier

    def initialize(identifier, &proc)
      @identifier = identifier
      instance_eval(&proc) if block_given?
    end

    def extract(document_or_nodes)
      if extractables.empty?
        result = ""
      else
        result = extractables.reduce(Hash.new) do |hash, extractable|
          hash.merge(extractable.extract(document_or_nodes))
        end
      end

      { @identifier => result }
    end

  end
end
