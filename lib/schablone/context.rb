module Schablone
  class Context
    attr_reader :navigator

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

    def visit(*uris)
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
