module Schablone
  class Context

    def initialize(page, navigator, emitter)
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
      throw :halt
    end

    def history
      @navigator.cached_uris
    end

    def visit(uri)
      @navigator.stage(uri)
    end

  end
end
