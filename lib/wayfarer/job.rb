require "hooks"
require "active_job"
require "capybara"

module Wayfarer
  class Job < ActiveJob::Base
    include Hooks

    define_hooks :before_crawl, :after_crawl

    Mismatch = Struct.new(:uri)
    Halt     = Struct.new(:uri, :method)
    Stage    = Struct.new(:uris)
    Error    = Struct.new(:exception, :backtrace)

    class << self
      def config
        @config ||= Wayfarer.config.clone
        yield(@config) if block_given?
        @config
      end

      def router(&proc)
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
        processor = Processor.new(self.config)
        processor.run(self, *uris)
      end

      private

      def method_added(method, &proc)
        return unless @head
        rule_opts, proc = @head
        router.draw(method, rule_opts, &(proc || proc {}))
        @head = nil
      end
    end

    attr_reader :staged_uris

    def initialize(*argv)
      super(*argv)
      @halts = false
      @staged_uris = []
    end

    def config(&proc)
      self.class.config(&proc)
    end

    def invoke(uri, adapter)
      method, @params = self.class.router.route(uri)
      return Mismatch.new(uri) unless method

      Wayfarer.log.debug("[#{self}] Dispatched to ##{method}: #{uri}")

      @adapter = adapter
      @page = adapter.fetch(uri)

      public_send(method)

      @halts ? Halt.new(uri, method) : Stage.new(@staged_uris)
    rescue => error
      return Error.new(error)
    end

    # ActiveJob
    def perform(*argv)
      self.class.crawl(*argv)
    end

    private

    attr_reader :adapter
    attr_reader :page
    attr_reader :params

    def log(*argv)
      Wayfarer.log.info(*argv)
    end

    def doc
      page.doc
    end

    def pismo
      page.pismo
    end

    def driver
      adapter.driver
    end

    def browser
      @browser ||= instantiate_capybara_driver
    end

    def instantiate_capybara_driver
      Capybara.run_server = false
      Capybara.current_driver = :selenium

      capybara_driver = Capybara::Selenium::Driver.new(nil)
      capybara_driver.instance_variable_set(:@browser, driver)

      session = Capybara::Session.new(:selenium, nil)
      session.instance_variable_set(:@driver, capybara_driver)

      session
    end

    def halt
      @halts = true
    end

    def stage(uris)
      @staged_uris += uris.respond_to?(:each) ? uris : [uris]
    end
  end
end
