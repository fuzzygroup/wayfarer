module Schablone
  class Emitter

    def emit(*args)
      yield(*args)
    end

  end
end