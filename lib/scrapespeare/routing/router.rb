module Scrapespeare
  module Routing
    class Router

      attr_reader :routing_table

      def initialize
        @routing_table = {}
      end

      def register(pattern_str, scraper_sym)
        @routing_table[Rule.new(pattern_str)] = scraper_sym
      end

      def route(uri)
        @routing_table.each do |rule, scraper_sym|
          return scraper_sym if rule === uri
        end

        nil
      end

    end
  end
end
