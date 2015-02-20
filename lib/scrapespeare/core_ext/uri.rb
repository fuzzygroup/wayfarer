require "uri"
require "rack/utils"

module URI

  def parsed_query
    Rack::Utils.parse_nested_query(self.query)
  end

  def parsed_fragment
    Rack::Utils.parse_nested_query(self.fragment)
  end

end
