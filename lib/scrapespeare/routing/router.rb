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

      def route(uri)
        @routing_table.each { |rule, scraper| return scraper if rule === uri }
        nil
      end

    end
  end
end
