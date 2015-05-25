require "connection_pool"

module Schablone
  module HTTPAdapters
    AdapterPool = ConnectionPool.new(size: 5, timeout: 5) do
      case Schablone.config.http_adapter
      when :net_http then NetHTTPAdapter.instance
      when :selenium then SeleniumAdapter.new
      end
    end
  end
end
