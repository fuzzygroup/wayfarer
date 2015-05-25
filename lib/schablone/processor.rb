require "thread"
require "connection_pool"

module Schablone
  class Processor
    attr_reader :router
    attr_reader :navigator
    attr_reader :adapter_pool
    attr_reader :workers

    def initialize(router)
      Thread.abort_on_exception = true

      @router    = router
      @navigator = Navigator.new
      @workers   = []
      @state     = :idle
      @mutex     = Mutex.new

      @adapter_pool = ConnectionPool.new(size: 5, timeout: 5) do
        case Schablone.config.http_adapter
        when :net_http then HTTPAdapters::NetHTTPAdapter.instance
        when :selenium then HTTPAdapters::SeleniumAdapter.new
        end
      end
    end

    def state
      @mutex.synchronize { @state }
    end

    def idle?;    self.state == :idle; end
    def running?; self.state == :running; end
    def halted?;  self.state == :halted; end

    def run
      step until halted?
    end

    def step
      self.state = :running
      @workers = spawn_workers(@navigator.current_uri_queue)
      @workers.each(&:join)
      @workers.clear
      halt unless @navigator.cycle
    end

    def halt
      return unless running?
      self.state = :halted
      @workers.each(&:kill)
      @workers.clear
      @adapter_pool.shutdown { |adapter| adapter.free }
    end

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
