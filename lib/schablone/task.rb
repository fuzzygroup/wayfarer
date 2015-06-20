module Schablone
  class Task
    class << self
      def router
        @router ||= Routing::Router.new
        @router.instance_eval(&proc) if block_given?
        @router
      end

      alias_method :route,  :router
      alias_method :routes, :router

      def crawl(*uris)
        Crawler.new.crawl(self, *uris)
      end
    end

    def initialize
      self.class.instance_variables.each do |instance_var|
        instance_variable_set(
          instance_var, self.class.instance_variable_get(instance_var)
        )
      end
    end

    def invoke(uri, adapter)
      method, @params = self.class.router.route(uri)
      return [] unless method

      @adapter = adapter
      @page = adapter.fetch(uri)

      public_send(method)
    end

    private

    attr_reader :adapter
    attr_reader :page
    attr_reader :params

    def halt
      Celluloid::Actor[:processor].halt
    end

    def visit(*uris)
      Celluloid::Actor[:navigator].async.stage(*uris)
    end
  end
end
