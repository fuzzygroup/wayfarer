require "ostruct"

module Schablone
  class Crawler
    attr_reader :router
    attr_reader :threadsafes
    attr_reader :uri_templates

    def initialize(&proc)
      @threadsafes = {}
      @uri_templates = {}
      @router = Routing::Router.new
      instance_eval(&proc) if block_given?
    end

    def helpers(*modules, &proc)
      Indexer.helpers(*modules, &proc)
    end

    def uri_template(key = :default, template_str)
      @uri_templates[key] = Mustermann.new(
        template_str, type: Schablone.config.mustermann_type
      )
    end

    def threadsafe(key, val = nil, &proc)
      threadsafe = @threadsafes[key] = Threadsafe.new(val || proc.call)
      helpers { define_method(key) { threadsafe } }
    end

    def index(sym, &proc)
      @router.register_payload(sym, &proc)
    end

    def crawl(*uris)
      processor = Processor.new(@router)
      processor.navigator.stage(uris)
      processor.navigator.cycle
      processor.run
    end

    def config(*argv, &proc)
      Schablone.configure(*argv, &proc)
    end

    def router(&proc)
      @router.instance_eval(&proc) if block_given?
      @router
    end

    private

    def respond_to_missing?(method, *)
      pismo_document.respond_to?(method) || super
    end
  end
end
