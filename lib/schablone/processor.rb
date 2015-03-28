require "pry"
require "thread"
require "thread/pool"

module Schablone
  class Processor

    def initialize(scraper, router)
      @scraper = scraper
      @router  = router

      @current_uris   = []
      @staged_uris    = []
      @processed_uris = []

      @fetcher = Fetcher.new

      @pool  = Thread.pool(4)
      @mutex = Mutex.new
    end

    def current_uris
      @mutex.synchronize { @current_uris }
    end

    def staged_uris
      @mutex.synchronize { @staged_uris }
    end

    def processed_uris
      @mutex.synchronize { @processed_uris }
    end

    private
    def step
      uri = staged_uris.shift
      page = @fetcher.fetch(uri)
      extract = nil
    end

    def stage(uri)
      return if current?(uri)   ||
                staged?(uri)    ||
                processed?(uri) ||
                forbidden?(uri)

      @staged_uris << uri
    end

    def current?(uri)
      @current_uris.include?(uri)
    end

    def staged?(uri)
      @staged_uris.include?(uri)
    end

    def processed?(uri)
      @processed_uris.include?(uri)
    end

    def forbidden?(uri)
      @router.forbids?(uri)
    end

    def cycle
      @current_uris, @staged_uris = staged_uris, []
    end

  end
end
