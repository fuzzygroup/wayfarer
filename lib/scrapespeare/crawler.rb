module Scrapespeare
  class Crawler

    def initialize(&proc)
      @scraper = Scraper.new
      @router  = Routing::Router.new

      instance_eval(&proc) if block_given?
    end

    def crawl(uri)
      processor = Processor.new(uri, @scraper, @router)
      processor.run
      processor.result
    end

    def setup_scraper(&proc)
      if block_given?
        proc.arity == 1 ? (yield @scraper) : @scraper.instance_eval(&proc)
      else
        @scraper
      end
    end

    alias_method :scraper, :setup_scraper

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
