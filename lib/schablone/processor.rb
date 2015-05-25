require "thread"

module Schablone
  class Processor
    attr_reader :router
    attr_reader :navigator
    attr_reader :workers

    def initialize(router)
      Thread.abort_on_exception = true

      @router    = router
      @navigator = Navigator.new
      @workers   = []
      @state     = :idle
      @mutex     = Mutex.new
    end

    def state
      @mutex.synchronize { @state }
    end

    def run
      puts "NOW RUNNING"
      return unless idle?
      self.state = :running

      until halted?
        puts "RUNNING. Current state: #{self.state}"
        puts "CURRENT URIS: #{@navigator.current_uris}"
        @workers = spawn_workers(@navigator.current_uri_queue)
        @workers.each(&:join)
        @workers.clear
        halt unless @navigator.cycle
      end

      puts "RECEIVED HALT. CACHED URIS: #{@navigator.cached_uris}"
    end

    def halt
      puts "NOW HALTING"
      return unless running?
      self.state = :halted
      @workers.each(&:kill)
      #HTTPAdapters::AdapterPool.shutdown { |adapter| adapter.free }
    end

    def idle?;    self.state == :idle; end
    def running?; self.state == :running; end
    def halted?;  self.state == :halted; end

    private

    def state=(sym)
      @mutex.synchronize { @state = sym }
    end

    def spawn_workers(queue)
      Schablone.config.thread_count.times.map do
        Worker.new(self, queue, @router)
      end
    end
  end
end
