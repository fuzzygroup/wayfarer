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
    val = Integer(get_query_param(key))
    set_query_param(key, val + incr)
  end

end

URI::HTTP.include(URIExt)
URI::HTTPS.include(URIExt)
