module Schablone
  class Crawler
    attr_reader :router
    attr_reader :emitter

    def initialize(&proc)
      @scraper = Extraction::Scraper.new
      @router  = Routing::Router.new
      @emitter = Emitter.new

      instance_eval(&proc) if block_given?
    end

    def crawl(uri)
      processor = Processor.new(uri, @scraper, @router)
      processor.run
      processor.result
    end

    def configure(*argv)
      Schablone.configure(*argv)
    end

    alias_method :config, :configure

    def register_handler(*argv)
      @router.register_handler(*argv)
    end

    def register_listener(sym, &proc)
      @emitter.register_listener(sym, &proc)
    end

    def setup_router(&proc)
      if block_given?
        proc.arity == 1 ? (yield @router) : @router.instance_eval(&proc)
      else
        @router
      end
    end

    alias_method :router, :setup_router
  end
end
