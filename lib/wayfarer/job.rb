# frozen_string_literal: true
require "hooks"
require "active_job"
require "capybara"

module Wayfarer
  # A {Job} is a class that has a {Routing::Router} with many {Routing::Rule}s
  # which are matched against a URI. If a rule matches the URI, the {Page} is
  # retrieved and the instance method associated with the matching rule is
  # called.
  #
  # Under the hood, jobs are instantiated within separate threads by a
  # {Processor}. Every instance gets its own thread.
  #
  # Because only jobs know whether URIs match their rules, jobs are responsible
  # for fetching pages. Jobs check out a HTTP adapter from
  # {HTTPAdapters::AdapterPool} over the whole invocation of their instance
  # methods. The adapter pool keeps track of how long adapters get checked out
  # and if a time limit is exceeded, an exception is raised. The time limit can
  # be set with the `connection_timeout` configuration key.
  #
  # Jobs implement ActiveJob's job api and are therefore compatible with a wide
  # range of job queues. To run a job immediately, call {#perform_now}. To
  # enqueue a job, run {#perform_later}.
  #
  # ## Configuring routes
  # @example By accessing the {router} directly
  #   class DummyJob < Wayfarer::Job
  #     route.draw :foo, uri: "https://example.com"
  #     route.draw :bar, uri: "https://w3c.org"
  #
  #     def foo; end
  #     def bar; end
  #   end
  #
  # @example By passing in a block
  #   class DummyJob < Wayfarer::Job
  #     routes do
  #       draw :foo, uri: "https://example.com"
  #       draw :bar, uri: "https://w3c.org"
  #     end
  #
  #     def foo; end
  #     def bar; end
  #   end
  #
  # @example By nesting blocks
  #   class DummyJob < Wayfarer::Job
  #     routes do
  #       draw :foo do
  #         uri "https://example.com"
  #       end
  #
  #       draw :bar do
  #         uri "https://w3c.org"
  #       end
  #     end
  #
  #     def foo; end
  #     def bar; end
  #   end
  class Job < ActiveJob::Base
    # @!method perform_later(username, message = "Quit")
    #   Sends a quit message to the server for a +username+.
    #   @param [String] username the username to quit
    #   @param [String] message the quit message

    include Hooks
    include Locals

    define_hooks :before_crawl, :after_crawl

    Mismatch = Struct.new(:uri)
    Halt     = Struct.new(:uri, :method)
    Stage    = Struct.new(:uris)
    Error    = Struct.new(:exception)

    class << self
      # The class' configuration, based off the global {Wayfarer::config}.
      # @yield [Routing::Router]
      def config
        @config ||= Wayfarer.config.clone
        yield(@config) if block_given?
        @config
      end

      # The class' router.
      # @yield [Routing::Router]
      def router(&proc)
        @router ||= Routing::Router.new
        @router.instance_eval(&proc) if block_given?
        @router
      end

      alias route router
      alias routes router

      # Adds a new route.
      # @see Routing::Rule#uri
      # @see Routing::Rule#host
      # @see Routing::Rule#path
      # @see Routing::Rule#query
      def draw(rule_opts = {}, &proc)
        @head = [rule_opts, proc]
      end

      def crawl(*uris)
        processor = Processor.new(config)
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

    # Implements ActiveJob's job API.
    def perform(*argv)
      self.class.crawl(*argv)
    end

    # @!method method1
    # @!method method2

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
