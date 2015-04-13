module Schablone
  class Context

    def initialize(processor, page, navigator, emitter)
      @processor = processor
      @page      = page
      @navigator = navigator
      @emitter   = emitter
    end

    def invoke(&proc)
      instance_eval(&proc)
    end

    private
    def page
      @page
    end

    def emit(*args)
      @emitter.emit(*args)
    end

    def halt
      @processor.halt
    end

    def history
      @navigator.cached_uris
    end

    def visit(uri)
      @navigator.stage(uri)
    end

  end
end
