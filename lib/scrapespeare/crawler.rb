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

    def route(&proc)
      @router.instance_eval(&proc)
    end

    alias_method :setup_routes, :route

    def config
      yield Scrapespeare.config if block_given?
    end

    alias_method :configure, :config

  end
end
