module Scrapespeare
  module Routing
    class Router

      attr_reader :routing_table

      def initialize
        @routing_table = {}
      end

      def register(pattern_str, scraper)
        rule = Rule.new(pattern_str)
        @routing_table[rule] = scraper
      end

      def recognized?(uri)
        @routing_table.keys.any? { |rule| rule === uri }
      end

      def route(uri)
      end

    end
  end
end
