require "connection_pool"

module Wayfarer
  module HTTPAdapters
    class AdapterPool
      def initialize
        size    = Wayfarer.config.pool_size
        timeout = Wayfarer.config.adapter_timeout || 10

        @pool = ConnectionPool.new(
          size: size, timeout: timeout, &method(:instantiate_adapter)
        )
      end

      def free
        @pool.shutdown { |adapter| adapter.free }
      end

      private

      def instantiate_adapter
        case Wayfarer.config.http_adapter
        when :net_http then HTTPAdapters::NetHTTPAdapter.instance
        when :selenium then HTTPAdapters::SeleniumAdapter.new
        end
      end

      def method_missing(method, *argv, &proc)
        super if method == :shutdown
        @pool.send(method, *argv, &proc)
      end

      def respond_to_missing?(method, private = false)
        return false if method == :shutdown
        @pool.respond_to?(method) || super
      end
    end
  end
end
