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

      def draw(rule_opts = {}, &proc)
        @head = [rule_opts, proc]
      end

      def method_added(method)
        return unless @head
        rule_opts, proc = @head
        router.draw(method, rule_opts, &(proc || Proc.new {}))
        @head = nil
      end

      def crawl(*uris)
        Crawler.new.crawl(self, *uris)
      end
    end

    def initialize
      self.class.instance_variables.each do |sym|
        instance_variable_set(sym, self.class.instance_variable_get(sym))
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

    def browser
      adapter.driver
    end

    def halt
      Celluloid::Notifications.notifier.publish("halt")
    end

    def visit(*uris)
      Celluloid::Actor[:navigator].async.stage(*uris)
    end
  end
end
