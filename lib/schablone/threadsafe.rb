require "thread"

module Schablone
  class Threadsafe
    def initialize(obj = nil, &proc)
      @obj = obj || proc.call
      @mutex = Mutex.new
    end

    def wrapped_object
      @obj
    end

    private

    def method_missing(*argv, &proc)
      @mutex.synchronize { @obj.send(*argv, &proc) }
    end

    def respond_to_missing?(method, private = false)
      @mutex.synchronize { @obj.respond_to?(method) || super }
    end
  end
end
