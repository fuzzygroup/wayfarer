require "thread"

module Schablone
  class Threadsafe
    def initialize(proc)
      @proc = proc
      @val = nil
      @mutex = Mutex.new
    end

    def wrapped_object
      @obj
    end

    private

    def evaluate
      @val 
    end

    def method_missing(*argv, &proc)
      @mutex.synchronize { @obj.send(*argv, &proc) }
    end

    def respond_to_missing?(method, private = false)
      @mutex.synchronize { @obj.respond_to?(method) || super }
    end
  end
end
