require "set"
require "thread"

module Schablone
  class Processor
    attr_reader :result
    attr_reader :navigator

    def initialize(entry_uri, scraper, router)
      @navigator = Navigator.new(router)
      @fetcher   = Fetcher.new
      @router    = router
      @result    = []

      @navigator.stage(entry_uri)
      @navigator.cycle
    end

    def run
      loop do
        workers = []

        Schablone.config.threads.times do
          workers << Worker.new(@navigator, @router, @fetcher)
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
