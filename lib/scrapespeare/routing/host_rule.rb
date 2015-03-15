module Scrapespeare
  module Routing
    class HostRule

      def initialize(str_or_regexp)
        @str_or_regexp = str_or_regexp
      end

      def matches?(uri)
        @str_or_regexp === uri.host
      end

    end
  end
end
