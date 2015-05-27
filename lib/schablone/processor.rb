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

      @adapter_pool = ConnectionPool.new(size: 16, timeout: 5) do
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
    rescue
      @adapter_pool.shutdown { |adapter| adapter.free }
      raise
    end

    def step
      self.state = :running

      thread_count = Schablone.config.thread_count
      slices(@navigator.current_uris, thread_count).each do |uris|
        @workers << Worker.new(self, uris, @router)
      end

      @workers.each(&:join)
      @workers.clear
      halt unless @navigator.cycle
    end

    def halt
      return unless running?
      self.state = :halted
      @workers.each(&:exit)
      @workers.clear
      @adapter_pool.shutdown { |adapter| adapter.free }
    end

    private

    def state=(sym)
      @mutex.synchronize { @state = sym }
    end

    def slices(array, subset_count)
      return [] if subset_count == 0
      subset_size = (array.size / subset_count.to_f).ceil
      array.each_slice(subset_size).to_a
    end
  end
end
