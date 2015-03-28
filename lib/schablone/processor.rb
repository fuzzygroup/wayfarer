require "set"
require "pry"
require "thread"
require "thread/pool"

module Schablone
  class Processor

    attr_reader :current_uris
    attr_reader :processed_uris

    def initialize
      @current_uris = []
      @staged_uris = Set.new
      @processed_uris = []
    end

    def staged_uris
      @staged_uris.to_a
    end

    private
    def stage(uri)
      @staged_uris << uri unless processed?(uri)
    end

    def current?(uri)
      @current_uris.include?(uri)
    end

    def processed?(uri)
      @processed_uris.include?(uri)
    end

    def cycle
      @current_uris, @staged_uris = @staged_uris, Set.new([])
    end

  end
end
