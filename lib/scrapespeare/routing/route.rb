require "mustermann"

module Scrapespeare
  module Routing
    class Route

      def initialize(pattern_str, scraper_sym)
        @pattern = Mustermann.new(pattern_str, type: :rails)
        @scraper_sym = scraper_sym
      end

      def matches?(uri)
        @pattern === uri.path
      end

      def invoke
        @scraper_sym
      end

    end
  end
end
