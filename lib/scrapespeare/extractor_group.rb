module Scrapespeare
  class ExtractorGroup

    include Extractable
    include Configurable

    # @return [Symbol]
    attr_reader :identifier

    # @param identifier [Symbol]
    # @param proc [Proc]
    def initialize(identifier, &proc)
      @identifier = identifier
      instance_eval(&proc) if block_given?
    end

    # TODO Documentation
    #
    # @param document_or_nodes [#css, #xpath]
    # @return [Hash]
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
