module Schablone
  class Emitter

    attr_reader :listeners

    def initialize
      @listeners = []
    end

    def subscribe(&proc)
      @listeners << proc
    end

    def emit(*args)
      @listeners.each { |listener| listener.call(*args) }
    end

  end
end