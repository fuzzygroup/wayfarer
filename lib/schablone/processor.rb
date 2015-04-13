require "thread"

module Schablone
  class Processor
    attr_reader :navigator
    attr_reader :workers

    def initialize(entry_uri, router, emitter)
      @router    = router
      @emitter   = emitter
      @navigator = Navigator.new(router)
      @fetcher   = Fetcher.new
      @workers   = []
      @state     = :idle
      @mutex     = Mutex.new

      @navigator.stage(entry_uri)
      @navigator.cycle
    end

    def state
      @mutex.synchronize { @state }
    end

    def state=(sym)
      @mutex.synchronize { @state = sym }
    end

    def run
      self.state = :running
      catch(:halt) { loop { step } }
    end

    def halt
      return false unless state == :running

      @workers.each(&:kill)
      @fetcher.free
      self.state = :halted

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

    def spawn_workers(queue)
      Schablone.config.threads.times do
        @workers << Worker.new(
          self, queue, @navigator, @router, @emitter, @fetcher
        )
      end
    end
  end
end
