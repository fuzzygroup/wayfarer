require "uri"
require "cgi"

module URI

  def parsed_query
    CGI.parse(self.query)
  end

  def parsed_fragment
    CGI.parse(self.fragment)
  end

end
