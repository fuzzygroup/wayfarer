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
    val
  end

  def get_query_param(key)
    self.parsed_query[key]
  end

end

URI::HTTP.include(URIExt)
URI::HTTPS.include(URIExt)
