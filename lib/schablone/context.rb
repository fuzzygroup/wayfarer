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

    def navigator
      @navigator
    end

    def visit(uri)
      @navigator.stage(uri)
    end

  end
end
