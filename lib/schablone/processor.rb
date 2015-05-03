require "thread"

module Schablone
  # @private
  #
  # A {Processor} is a state-machine in disguise. It spawns a number of
  # {Worker}s that are responsible for executing the actual {Scraper}s.
  #
  # Initially, its state is set to `:idle`:
  # ```
  # processor.state # => :idle
  # ```
  #
  # It also has not spawned any {Worker}s:
  # ```
  # processor.workers.count # => 0
  # ```
  #
  # Suppose its {#router} has been set up. 
  # ```
  # processor.workers.count # => 0
  # ```
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
    attr_reader :router
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

    # Runs the processor by calling {#step} until `:halt` is thrown.
    # Sets {#state} to `:running`.
    def run
      @state = :running
      catch(:halt) { loop { step } }
    end

    # Halts the {Processor} if {#state} returns `:running`:
    # 1. Calls {HTTPAdapters::Factory.free_instances}
    # 2. Sends `#kill` to all its {#workers}
    # 3. Sets {#state} to `:halted`
    # 4. Throws `:halt`
    #
    # @return [false] if {#state} is not `:running`
    def halt
      return false unless state == :running

      HTTPAdapters::Factory.free_instances
      @workers.each(&:kill)
      @state = :halted

      throw(:halt)
    end

    private

    def step
      queue = @navigator.current_uri_queue
      spawn_workers(queue)
      @workers.each(&:join)
      @workers.clear
      halt unless @navigator.cycle
    end

    # Spawns a number of {Worker}s and passes them the `Queue` of current URIs
    # provided by {Navigator#current_uri_queue}
    #
    # @return [false] if {#state} is not `:running`
    def spawn_workers(queue)
      @workers = Schablone.config.threads.times.map do
        Worker.new(self, queue, @navigator, @router, @emitter)
      end
    end
  end
end
