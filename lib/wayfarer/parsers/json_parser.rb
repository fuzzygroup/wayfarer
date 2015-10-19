module Wayfarer
  module Parsers
    # A wrapper class for parsing JSON
    module JSONParser
      module_function

      # Parses a JSON string.
      # @param [String] the JSON string to parse.
      # @return [OpenStruct]
      def parse(json_str)
        if defined?(Oj)
          Oj.load(json_str)
        else
          require "json"
          JSON.parse(json_str)
        end
      end
    end
  end
end
