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
      @adapter   = http_adapter
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

        @workers.each { |worker| worker.http_adapter.free }

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
      Schablone.config.threads.times do
        @workers << Worker.new(
          self, queue, @navigator, @router, @emitter, @adapter
        )
      end
    end

    def http_adapter
      if Schablone.config.http_adapter == :net_http
        HTTPAdapters::NetHTTPAdapter.new
      end
    end

  end
end
