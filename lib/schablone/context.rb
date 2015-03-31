module Schablone
  class Context

    def initialize(page, navigator)
      @page = page
      @navigator = navigator
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
