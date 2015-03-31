module Schablone
  class Context

    def initialize(page, navigator)
      @page = page
      @navigator = navigator
    end

    def invoke(&proc)
      instance_eval(&proc)
    end

    private
    def page
      @page
    end

    def history
      @navigator.cached_uris
    end

    def visit(uri)
      @navigator.stage(uri)
    end

  end
end
