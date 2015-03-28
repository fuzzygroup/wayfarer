require "pry"
require "thread"
require "thread/pool"

module Schablone
  class Processor

    attr_reader :current_uris
    attr_reader :staged_uris
    attr_reader :processed_uris

    def initialize
      @current_uris = []
      @staged_uris = []
      @processed_uris = []
    end

    private
    def stage(uri)
      @staged_uris << uri unless processed?(uri)
    end

    def processed?(uri)
      @processed_uris.include?(uri)
    end

  end
end
