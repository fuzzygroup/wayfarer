require "uri"
require "rack/utils"

module URI

  def parsed_query
    Rack::Utils.parse_nested_query(self.query)
  end

  def set_query_param(key, val)
    self.query = Rack::Utils.build_query(
      self.parsed_query.merge({ key => val })
    )
  end

  def get_query_param(key)
    self.parsed_query[key]
  end

end
