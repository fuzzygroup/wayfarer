module Scrapespeare
  class Crawler

    def initialize(&proc)
      @scraper = Scraper.new
      @router  = Router.new

      instance_eval(&proc) if block_given?
    end

    def crawl(uri)
    end

    def setup_scraper(&proc)
      block_given? ? @scraper.instance_eval(&proc) : @scraper
    end

    alias_method :scraper, :setup_scraper

    def setup_router(&proc)
      block_given? ? @router.instance_eval(&proc) : @router
    end

    alias_method :router, :setup_router

    def config
      yield Scrapespeare.config if block_given?
    end

    alias_method :configure, :config

  end
end
