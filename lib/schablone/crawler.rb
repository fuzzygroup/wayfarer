module Schablone
  class Crawler
    attr_reader :router
    attr_reader :emitter
    attr_reader :scrapers

    def initialize(&proc)
      @router = Routing::Router.new
      @emitter = Emitter.new

      instance_eval(&proc) if block_given?
    end

    def helpers
    end

    def scrape(sym, obj = nil, &proc)
      @router.register_scraper(sym, obj, &proc)
    end

    def crawl(uri)
      Processor.new(URI(uri), @router, @emitter).run
    end

    def config(*argv, &proc)
      Schablone.configure(*argv, &proc)
    end

    def router(&proc)
      if block_given?
        proc.arity >= 1 ? (yield @router) : @router.instance_eval(&proc)
      else
        @router
      end
    end
  end
end
