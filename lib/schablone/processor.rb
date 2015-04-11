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

      @navigator.stage(entry_uri)
      @navigator.cycle
    end

    def run
      catch(:halt) { loop { step } }
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
        @workers << Worker.new(queue, @navigator, @router, @emitter, @fetcher)
      end
    end

    def halt
      @fetcher.free
      throw(:halt)
    end
  end
end
