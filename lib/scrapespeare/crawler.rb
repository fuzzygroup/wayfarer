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
      block_given? ? @scraper.instance_eval(&proc) : @scraper
    end

    alias_method :scraper, :setup_scraper

    def setup_router(&proc)
      block_given? ? @router.instance_eval(&proc) : @router
    end

    alias_method :router, :setup_router

  end
end
