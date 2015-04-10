require "thread"

module Schablone
  class Processor
    attr_reader :result
    attr_reader :navigator

    def initialize(entry_uri, router, emitter)
      @router    = router
      @emitter   = emitter
      @navigator = Navigator.new(router)
      @fetcher   = Fetcher.new

      @navigator.stage(entry_uri)
      @navigator.cycle
    end

    def run
      loop do
        queue = @navigator.current_uri_queue

        workers = Schablone.config.threads.times.map do
          Worker.new(queue, @navigator, @router, @emitter, @fetcher)
        end

        workers.each(&:join)

        unless @navigator.cycle
          workers.each(&:kill)
          @fetcher.free
          break
        end
      end
    end
  end
end
