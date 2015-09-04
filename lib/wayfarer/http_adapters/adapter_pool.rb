require "connection_pool"

module Wayfarer
  module HTTPAdapters
    class AdapterPool
      def initialize
        size    = Wayfarer.config.connection_count
        timeout = Wayfarer.config.connection_timeout

        @pool = ConnectionPool.new(
          size: size, timeout: timeout, &method(:instantiate_adapter)
        )
      end

      def free
        @pool.shutdown(&:free)
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
        @pool.public_send(method, *argv, &proc)
      end

      def respond_to_missing?(method, private = false)
        return false if method == :shutdown
        @pool.respond_to?(method) || super
      end
    end
  end
end
