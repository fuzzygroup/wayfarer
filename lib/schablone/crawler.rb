require "ostruct"

module Schablone
  class Crawler
    attr_reader :router
    attr_reader :locals
    attr_reader :uri_templates

    def initialize(&proc)
      @locals = {}
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

    def let(key, val)
      register_local(key, Threadsafe.new(val))
    end

    def let!(key, val)
      register_local(key, val)
    end

    def index(sym, &proc)
      @router.register_payload(sym, &proc)
    end

    def crawl(*uris)
      processor = Processor.new(@router)
      processor.navigator.stage(uris)
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

    def method_missing(method, &proc)
      if method =~ /^crawl_(\w+)$/
        
      end
    end

    def respond_to_missing?(method, *)
      pismo_document.respond_to?(method) || super
    end
  end
end
