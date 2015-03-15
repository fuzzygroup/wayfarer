module Scrapespeare
  module Routing
    class Rule

      def initialize(&proc)
      end

      def matches?(uri)
        false
      end

    end
  end
end
