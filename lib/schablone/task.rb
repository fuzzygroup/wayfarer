module Schablone
  class Task
    Mismatch = Struct.new(:uri)
    Halt     = Struct.new(:uri, :halting_method)
    Stage    = Struct.new(:uris)
    Error    = Struct.new(:exception, :backtrace)

    class << self
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
      @halts = false
      @staged_uris = []
    end

    def config(&proc)
      self.class.config(&proc)
    end

    def invoke(uri, adapter)
      method, @params = self.class.router.route(uri)
      return Mismatch.new(uri) unless method

      @adapter = adapter
      @page = adapter.fetch(uri)

      public_send(method)

      @halts ? Halt.new(uri, method) : Stage.new(@staged_uris)
    end

    private

    attr_reader :adapter
    attr_reader :page
    attr_reader :params

    def doc
      page.doc
    end

    def pismo
      page.pismo
    end

    def browser
      adapter.driver
    end

    def halt
      @halts = true
    end

    def visit(uris)
      @staged_uris += uris.respond_to?(:each) ? uris : [uris]
    end
  end
end
