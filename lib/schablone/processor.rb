require "thread"

module Schablone
  # @private
  #
  # A {Processor} decorates a `Set` and differs in behaviour of {#add} and
  # {#include?}. URIs are stored as Strings internally.
  #
  # {#add} normalizes the passed URI by removing trailing slashes and
  # fragment identifiers:
  #
  # ```
  # uri_set << URI("http://example.com/#fragment-identifier")
  # uri_set.to_a.first # => #<URI::HTTP:... URL:http://example.com>
  # ```
  #
  # {#include?} normalizes the passed URI before checking for membership:
  # ```
  # uri_set << URI("http://example.com/#fragment-identifier")
  # uri_set.include?(URI("http://example.com")) # => true
  # ```
  # @param enumerable [Enumerable]
  class Processor
    attr_reader :navigator
    attr_reader :workers
    attr_reader :state

    def initialize(entry_uri, router, emitter)
      @router    = router
      @emitter   = emitter
      @navigator = Navigator.new(router)
      @workers   = []
      @state     = :idle
      @mutex     = Mutex.new

      @navigator.stage(entry_uri)
      @navigator.cycle
    end

    def run
      @state = :running
      catch(:halt) { loop { step } }
    end

    def halt
      @mutex.synchronize do
        return false unless @state == :running

        HTTPAdapters::Factory.free_instances
        @workers.each(&:kill)
        @state = :halted

        throw(:halt)
      end
    end

    private

    def step
      queue = @navigator.current_uri_queue
      spawn_workers(queue)
      @workers.each(&:join)
      @workers.clear
      halt unless @navigator.cycle
    end

    def spawn_workers(queue)
      @workers = Schablone.config.threads.times.map do
        Worker.new(self, queue, @navigator, @router, @emitter)
      end
    end
  end
end
