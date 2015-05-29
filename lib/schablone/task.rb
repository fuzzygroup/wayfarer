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
    end

    def invoke(uri)
      method, @params = self.class.router.route(uri)

      return unless method && respond_to?(method)

      HTTPAdapters::AdapterPool.with do |adapter|
        @adapter = adapter
        @page = adapter.fetch(uri)
        public_send(method)
      end
    end

    private

    attr_reader :adapter
    attr_reader :page
    attr_reader :params

    def halt
      Celluloid::Notifications.notifier.publish("halt")
    end

    def visit(*uris)
      Celluloid::Actor[:navigator].async.stage(*uris)
    end
  end
end
