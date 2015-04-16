require "thread"

module Schablone
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
