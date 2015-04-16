module Schablone
  module HTTPAdapters
    module Factory

      module_function

      def instances
        @instances ||= []
      end

      def instance
        case Schablone.config.http_adapter
        when :net_http
          instances << NetHTTPAdapter.new if instances.empty?
          instances.first
        when :selenium
          (instances << SeleniumAdapter.new).last
        end
      end

      def free_instances
        instances.each(&:free)
        instances.clear
      end

    end
  end
end
