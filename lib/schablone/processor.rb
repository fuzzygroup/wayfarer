require "pry"
require "thread"
require "thread/pool"

module Schablone
  class Processor

    def initialize
      @current_uris   = []
      @staged_uris    = []
      @processed_uris = []

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
    def prefetch

    end

    def stage(uri)
      return if current?(uri) || staged?(uri) || processed?(uri)
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

    def cycle
      @current_uris, @staged_uris = staged_uris, []
    end

  end
end
