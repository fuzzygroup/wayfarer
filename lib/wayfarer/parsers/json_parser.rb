module Wayfarer
  module Parsers
    module JSONParser
      module_function

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
