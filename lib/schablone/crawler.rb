module Schablone
  class Crawler
    attr_reader :router

    def initialize(&proc)
      @router = Routing::Router.new
      instance_eval(&proc) if block_given?
    end

    def helpers(*modules, &proc)
      Context.helpers(*modules, &proc)
    end

    def let(key, val)
    end

    def scrape(sym, obj = nil, &proc)
      @router.register_scraper(sym, obj, &proc)
    end

    def crawl(uri)
      Processor.new(URI(uri), @router).run
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
