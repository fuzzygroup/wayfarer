require "connection_pool"

module Schablone
  module HTTPAdapters
    class AdapterPool
      def initialize
        size    = Schablone.config.pool_size
        timeout = Schablone.config.adapter_timeout || 10

        @pool = ConnectionPool.new(
          size: size, timeout: timeout, &method(:instantiate_adapter)
        )
      end

      def free
        @pool.shutdown { |adapter| adapter.free }
      end

      private

      def instantiate_adapter
        case Schablone.config.http_adapter
        when :net_http then HTTPAdapters::NetHTTPAdapter.instance
        when :selenium then HTTPAdapters::SeleniumAdapter.new
        end
      end

      def method_missing(method, *argv, &proc)
        @pool.send(method, *argv, &proc) unless method == :shutdown
      end

      def respond_to_missing?(method, private = false)
        @pool.respond_to?(method) || super
      end
    end
  end
end
