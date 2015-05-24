require "thread"

module Schablone
  class Processor
    attr_reader :router
    attr_reader :navigator
    attr_reader :workers

    def initialize(entry_uri, router)
      @router    = router
      @navigator = Navigator.new(router)
      @workers   = []
      @state     = :idle
      @mutex     = Mutex.new

      @navigator.stage(entry_uri)
      @navigator.cycle
    end

    def state
      @mutex.synchronize { @state }
    end

    def run
      self.state = :running
      catch(:halt) { loop { step } }
      self.state = :halted
    end

    def step
      spawn_workers(@navigator.current_uri_queue)
      @workers.each(&:join)
      @workers.clear
      halt unless @navigator.cycle
    end

    def halt
      return false unless self.state == :running
      @workers.each(&:kill)
      throw(:halt)
    end

    private

    def state=(sym)
      @mutex.synchronize { @state = sym }
    end

    def spawn_workers(queue)
      @workers = Schablone.config.threads.times.map do
        Worker.new(self, @navigator, queue, @router)
      end
    end
  end
end
