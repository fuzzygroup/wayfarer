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
        block_given? ? @whitelist.instance_eval(&proc) : @whitelist
      end

      def forbid(&proc)
        block_given? ? @blacklist.instance_eval(&proc) : @blacklist
      end

      def allows?(uri)
        !@blacklist.matches?(uri) and @whitelist.matches?(uri)
      end

      def forbids?(uri)
        !allows?(uri)
      end

      private
      def register_scraper(scraper_sym)
      end

    end
  end
end
