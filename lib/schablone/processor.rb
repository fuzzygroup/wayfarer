require "set"
require "thread"

module Schablone
  class Processor
    attr_reader :result
    attr_reader :navigator

    def initialize(entry_uri, scraper, router)
      @scraper = scraper
      @navigator = Navigator.new(router)
      @fetcher = Fetcher.new
      @router = router
      @result = []

      @navigator.stage(entry_uri)
      @navigator.cycle
    end

    def run
      loop do
        queue = @navigator.current_uri_queue
        threads = []

        Schablone.config.threads.times do
          threads << Worker.new(@navigator, @router, @fetcher)
        end

        threads.each(&:join)

        unless @navigator.cycle
          threads.each(&:kill)
          @fetcher.free
          break
        end
      end
    end
  end
end
