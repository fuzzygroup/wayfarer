# frozen_string_literal: true
require "thread_safe"

module Wayfarer
  # @api private
  module Locals
    def self.included(base)
      base.extend(ClassMethods)
    end

    module InstanceMethods
      def locals
        self.class.locals
      end
    end

    include InstanceMethods

    module ClassMethods
      include InstanceMethods

      def let(key)
        locals[key] = case val = yield
                      when Array then ThreadSafe::Array.new(val)
                      when Hash  then ThreadSafe::Hash.new(val)
                      else val
                      end
      end

      def locals
        @locals ||= {}
      end

      def locals=(locals)
        @locals = locals
      end
    end
  end
end
