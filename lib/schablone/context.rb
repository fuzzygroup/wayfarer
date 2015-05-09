require "thread"

module Schablone
  class Context
    def initialize(processor, navigator, adapter, page,  params)
      @processor = processor
      @navigator = navigator
      @adapter   = adapter
      @page      = page
      @params    = params
    end

    def self.helpers(*modules, &proc)
      include(*modules) if modules.any?
      class_eval(&proc) if block_given?
    end

    def evaluate(&proc)
      instance_eval(&proc)
    end

    private
    def params
      @params
    end

    def page
      @page
    end

    def adapter
      @adapter
    end

    def halt
      @processor.halt
    end

    def visit(*uris)
      @navigator.stage(*uris)
    end
  end
end
