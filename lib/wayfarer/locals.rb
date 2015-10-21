require "thread_safe"

module Wayfarer
  module Locals
    def self.included(base)
      base.extend(ClassMethods)
    end

    def method_missing(key)
      self.class.locals[key] || super
    end

    def respond_to_missing?(key, private = false)
      self.class.locals.key?(key)
    end

    module ClassMethods
      def let(key, &proc)
        locals[key] = case val = proc.call
                      when Array then ThreadSafe::Array.new(val)
                      when Hash  then ThreadSafe::Hash.new(val)
                      else val
                      end
      end
  
      def locals
        @locals ||= {}
      end
    end
  end
end
