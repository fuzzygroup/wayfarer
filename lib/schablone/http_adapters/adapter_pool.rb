module Schablone
  module HTTPAdapters
    module AdapterPool

      module_function

      def instances
        @instances ||= []
      end

      def instance(adapter = nil)
        case adapter || Schablone.config.http_adapter
        when :net_http
          instances << NetHTTPAdapter.new if instances.empty?
          # TODO breaks now
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
