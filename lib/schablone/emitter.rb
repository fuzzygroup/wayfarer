module Schablone
  class Emitter

    attr_reader :listeners

    def initialize
      @listeners = {}
    end

    def subscribe(sym, &proc)
      @listeners[sym] = proc
    end

    def emit(sym, *args)
      @listeners[sym].call(*args)
    end

  end
end