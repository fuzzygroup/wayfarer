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
      Processor.new(uri, @router, @emitter).run
    end

    def configure(*argv, &proc)
      Schablone.configure(*argv, &proc)
    end

    alias_method :config, :configure

    def register_handler(*argv, &proc)
      @router.register_handler(*argv, &proc)
    end

    alias_method :handle, :register_handler

    def register_listener(*argv, &proc)
      @emitter.register_listener(*argv, &proc)
    end

    alias_method :listen, :register_listener

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
