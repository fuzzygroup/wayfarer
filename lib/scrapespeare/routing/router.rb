module Scrapespeare
  module Routing
    class Router

      attr_reader :whitelist
      attr_reader :blacklist

      def initialize
        @whitelist = Rule.new
        @blacklist = Rule.new
      end

      def allow(&proc)
        @whitelist.instance_eval(&proc)
      end

      def forbid(&proc)
        @blacklist.instance_eval(&proc)
      end

    end
  end
end
