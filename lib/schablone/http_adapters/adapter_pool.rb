module Schablone
  module HTTPAdapters
    AdapterPool = ConnectionPool.new(size: 3, timeout: 5) do
      case Schablone.config.http_adapter
      when :net_http then Schablone::HTTPAdapters::NetHTTPAdapter.instance
      when :selenium then Schablone::HTTPAdapters::SeleniumAdapter.new
      end
    end
  end
end
