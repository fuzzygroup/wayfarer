# frozen_string_literal: true
require "forwardable"
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
  # for fetching pages. Jobs hold a checked out HTTP adapter over the whole
  # invocation of their instance methods. The adapter pool keeps track of how
  # long adapters get checked out. If a time limit is exceeded, an exception is
  # raised. The time limit can be set with the `connection_timeout`
  # configuration key.
  #
  # Jobs implement ActiveJob's job api and are therefore compatible with a wide
  # range of job queues. To run a job immediately, call #perform_now. To
  # enqueue a job, run #perform_later.
  #
  # @see https://github.com/rails/rails/tree/master/activejob rails/activejob
  # @see http://edgeguides.rubyonrails.org/active_job_basics.html ActiveJob Basics
  class Job < ActiveJob::Base
    extend Forwardable

    include Hooks
    include Locals

    # @!group Callbacks
    # @!scope class

    # Callback that fires __once__ serially on the main thread before any pages
    # are retrieved.
    # @method before_crawl
    # @scope class

    # Callback that fires __once__ serially on the main thread after all pages
    # have been retrieved and processing is done.
    # @method after_crawl
    # @scope class
    define_hooks :before_crawl, :after_crawl

    # @!endgroup

    class << self
      attr_writer :router

      # A configuration based off the global {Wayfarer.config}.
      # @yield [Configuration]
      # @return [Configuration]
      def config
        @config ||= Wayfarer.config.clone
        yield(@config) if block_given?
        @config
      end

      # A router.
      # If a block is passed in, it is evaluated within the {Router}'s instance.
      # @return [Routing::Router]
      def router(&proc)
        @router ||= Routing::Router.new
        @router.instance_eval(&proc) if block_given?
        @router
      end

      alias route router
      alias routes router

      # Draws a new route to the next defined instance method.
      # @param [Routing::Router]
      def draw(rule_opts = {}, &proc)
        @head = [rule_opts, proc]
      end

      # Draws a new route to the next defined instance method.
      # @param [*Array<String>, *Array<URI>] uris
      # @api private
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

    # @!attribute [r] staged_uris
    # @return [Array<String>, Array<URI>] URIs staged for the next cycle.
    # @see #stage
    attr_reader :staged_uris

    attr_writer :page

    def initialize(*argv)
      super(*argv)
      @halts = false
      @staged_uris = []
    end

    # @see ::config
    def config(&proc)
      self.class.config(&proc)
    end

    # Whether this job will stop processing.
    def halts?
      @halts
    end

    # Implements ActiveJob's job API.
    def perform(*argv)
      self.class.crawl(*argv)
    end

    protected

    # @!attribute [r] page
    # @return [Page] The retrieved page.
    attr_reader :page

    # @!attribute [r] params
    # @return [Hash] The parameters, if any, extracted from the matching rule.
    attr_reader :params

    # Signals the processor to stop its work.
    def halt
      @halts = true
    end

    # Adds URIs to process in the next cycle.
    # @param [String, URI, Array<String>, Array<URI>]
    def stage(uris)
      @staged_uris += uris.respond_to?(:each) ? uris : [uris]
    end

    # Prints a log message with `info` level.
    def log(*argv)
      Wayfarer.log.info(*argv)
    end

    # The parsed response body.
    # @method doc
    # @see Page#doc
    delegate [:doc] => :page

    # A Pismo document.
    # @method pismo
    # @see https://github.com/peterc/pismo Pismo
    # @see Page#pismo
    delegate [:pismo] => :page

    # The Selenium WebDriver.
    # @method driver
    # @see https://github.com/peterc/pismo Pismo
    # @see Page#driver
    delegate [:driver] => :adapter

    # A Capybara driver that wraps the {#driver}.
    # @see https://github.com/teamcapybara/capybara Capybara
    def browser
      @browser ||= instantiate_capybara_driver
    end

    private

    attr_reader :adapter

    def instantiate_capybara_driver
      Capybara.run_server = false
      Capybara.current_driver = :selenium

      capybara_driver = Capybara::Selenium::Driver.new(nil)
      capybara_driver.instance_variable_set(:@browser, driver)

      session = Capybara::Session.new(:selenium, nil)
      session.instance_variable_set(:@driver, capybara_driver)

      session
    end
  end
end
