# frozen_string_literal: true
require "thread_safe"

module Wayfarer
  # @api private
  module Locals
    def self.included(base)
      base.extend(ClassMethods)
    end

    def locals
      self.class.locals
    end

    module InstanceMethods
      def method_missing(method, *argv, &proc)
        locals.keys.include?(method) ? locals[method] : super
      end

      def respond_to_missing?(method, private = false)
        locals.keys.include?(method) || super
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
