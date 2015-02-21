require "uri"
require "rack/utils"

module URIExt

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

  def increment_query_param(key, incr = 1)
    if val = self.get_query_param(key)
      self.set_query_param(key, Integer(val) + incr)
    else
      self.set_query_param(key, 2)
    end
  end

end

URI::HTTP.include(URIExt)
URI::HTTPS.include(URIExt)
