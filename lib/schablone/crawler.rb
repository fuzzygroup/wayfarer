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
      Processor.new(URI(uri), @router).run

      @locals.reduce(OpenStruct.new) do |ostruct, (key, threadsafe)|
        ostruct.send(key, threadsafe.wrapped_object)
      end
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

    private

    def register_local(key, val)
      @locals[key] = val
      helpers { define_method(key) { @locals[key] } }
    end
  end
end
