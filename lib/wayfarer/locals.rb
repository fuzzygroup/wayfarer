require "forwardable"

module Wayfarer
  module Locals
    def self.included(base)
      base.extend(ClassMethods)
    end

    def method_missing(key)
      self.class.locals[key] || super
    end

    module ClassMethods
      def let(key, &proc)
        locals[key] = proc.call
      end
  
      def locals
        @locals ||= {}
      end
    end
  end
end
