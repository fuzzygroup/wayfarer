require "thread"

module Schablone
  class Indexer
    attr_reader :adapter, :page, :params

    def initialize(processor, adapter, page, params)
      @processor = processor
      @adapter   = adapter
      @page      = page
      @params    = params
    end

    def self.helpers(*modules, &proc)
      include(*modules) if modules.any?
      class_eval(&proc) if block_given?
    end

    def evaluate(payload)
      instance_eval(&payload)
    end

    private

    def halt
      @processor.halt
    end

    def visit(*uris)
      @processor.navigator.stage(*uris)
    end
  end
end
