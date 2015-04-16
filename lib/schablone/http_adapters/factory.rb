module Schablone
  module HTTPAdapters
    module Factory

      module_function

      def adapter_instance
        case Schablone.config.http_adapter
        when :net_http
          @adapter ||= NetHTTPAdapter.new
        when :selenium
          SeleniumAdapter.new
        end
      end

    end
  end
end
