module Schablone
  class Emitter

    attr_reader :listeners

    def initialize
      @listeners = {}
    end

    def register_listener(sym, &proc)
      @listeners[sym] = proc
    end

    def emit(sym, *args)
      (listener = @listeners[sym]) ? listener.call(*args) : false
    end

  end
end