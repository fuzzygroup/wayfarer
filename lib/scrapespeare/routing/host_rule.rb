module Scrapespeare
  module Routing
    class HostRule

      def initialize(host_str)
        @host_str = host_str
      end

      def matches?(uri)
        @host_str == uri.host
      end

    end
  end
end
