module Scrapespeare
  module Routing
    class HostRule < Rule

      def initialize(str_or_regexp, &proc)
        @str_or_regexp = str_or_regexp
        super(&proc)
      end

      def matches?(uri)
        @str_or_regexp === uri.host
      end

    end
  end
end
