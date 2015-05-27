require "mustermann" unless RUBY_PLATFORM == "java"

module Schablone
  module Routing
    class PathRule < Rule
      attr_reader :pattern

      def initialize(pattern_str, opts = {}, &proc)
        if RUBY_PLATFORM != "java"
          @pattern = Mustermann.new(pattern_str, type: :template)
        else
          @pattern = pattern_str
        end

        super(opts, &proc)
      end

      def match!(uri)
        RUBY_PLATFORM != "java" ? @pattern === uri.path : @pattern == uri.to_s
      end
    end
  end
end
