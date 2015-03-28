require "pry"
require "thread"
require "thread/pool"

module Schablone
  class Processor

    attr_reader :current_uris
    attr_reader :processed_uris

    def initialize
      @current_uris = []
      @staged_uris = []
      @processed_uris = []
    end

    def staged_uris
      @staged_uris.to_a
    end

    private
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
