# frozen_string_literal: true
require "json" unless defined?(Oj)

module Wayfarer
  module Parsers
    # A wrapper class for parsing JSON.
    # @private
    module JSONParser
      module_function

      # Parses a JSON string.
      # @param [String] json_str the JSON string to parse.
      # @return [OpenStruct]
      def parse(json_str)
        defined?(Oj) ? Oj.load(json_str) : JSON.parse(json_str)
      end
    end
  end
end
