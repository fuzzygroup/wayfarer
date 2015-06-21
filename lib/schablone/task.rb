module Schablone
  class Task
    class << self
      attr_reader :locals

      def config(&proc)
        @config ||= Schablone.config.dup
        yield(@config) if block_given?
        @config
      end

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

      def let(sym, &proc)
        @locals ||= {}

        @locals[sym] = proc.call

        instance_eval do
          define_method(sym) { @locals[sym] }
        end
      end

      def crawl(*uris)
        Crawler.new.crawl(self, *uris)
      end

      private

      def method_added(method)
        return unless @head
        rule_opts, proc = @head
        router.draw(method, rule_opts, &(proc || Proc.new {}))
        @head = nil
      end
    end

    attr_reader :staged_uris

    def initialize
      @will_halt = false
      @staged_uris = []
    end

    def locals
      self.class.locals
    end

    def will_halt?
      @will_halt
    end

    def config(&proc)
      self.class.config(&proc)
    end

    def invoke(uri, adapter)
      method, @params = self.class.router.route(uri)
      return [] unless method

      Celluloid.logger.info("Dispatching to `#{method}`: #{uri}")

      @adapter = adapter
      @page = adapter.fetch(uri)

      public_send(method)

      @will_halt ? :halt : @staged_uris
    end

    private

    attr_reader :adapter
    attr_reader :page
    attr_reader :params

    def browser
      adapter.driver
    end

    def halt!
      @will_halt = true
    end

    def visit(uris)
      uris = *uris unless uris.respond_to?(:each)
      @staged_uris += uris
    end
  end
end
