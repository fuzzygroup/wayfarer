module Schablone
  class Crawler
    attr_reader :router

    def initialize(&proc)
      @scraper = Extraction::Scraper.new
      @scraper_table = {}
      @router  = Routing::Router.new(@scraper_table)
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

    def register_scraper(*argv)
      @router.register(*argv)
    end

    alias_method :scraper, :register_scraper

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
