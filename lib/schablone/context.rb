module Schablone
  class Context
    attr_reader :handler
    attr_reader :navigator

    def initialize(handler, processor, page, navigator, emitter)
      @handler   = handler
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
      @emitter.emit(@handler, *args)
    end

    def halt
      @processor.halt
    end

    def history
      @navigator.cached_uris
    end

    def visit(uris)
      uris = *uris unless uris.respond_to?(:each)
      uris.each { |uri| @navigator.stage(URI(uri)) }
    end

    def extract(&proc)
      Extraction::Scraper.new(&proc).extract(@page.parsed_document)
    end

    def extract!(&proc)
      emit(extract(&proc))
    end

  end
end
