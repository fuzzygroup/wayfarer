require "ostruct"

module Schablone
  class Crawler
    attr_reader :router
    attr_reader :locals

    def initialize(&proc)
      @locals = {}
      @router = Routing::Router.new
      instance_eval(&proc) if block_given?
    end

    def helpers(*modules, &proc)
      Indexer.helpers(*modules, &proc)
    end

    def let(key, val)
      register_local(key, Threadsafe.new(val))
    end

    def let!(key, val)
      register_local(key, val)
    end

    def scrape(sym, &proc)
      @router.register_scraper(sym, &proc)
    end

    def crawl(uri)
      processor = Processor.new(@router)
      processor.navigator.stage(uri)
      processor.navigator.cycle
      processor.run

      @locals.reduce(OpenStruct.new) do |ostruct, (key, threadsafe)|
        ostruct[key] = threadsafe.wrapped_object; ostruct
      end
    end

    def config(*argv, &proc)
      Schablone.configure(*argv, &proc)
    end

    def router(&proc)
      @router.instance_eval(&proc) if block_given?
      @router
    end

    private

    def register_local(key, val)
      @locals[key] = val
      helpers { define_method(key) { @locals[key] } }
    end
  end
end
