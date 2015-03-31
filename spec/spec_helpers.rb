require "schablone"

include Schablone
include Schablone::Extraction
include Schablone::Routing

module SpecHelpers
  def fetch_page(uri)
    Fetcher.new.fetch(URI(uri))
  end

  def html_fragment(html_string)
    Nokogiri::HTML.fragment(html_string)
  end

  def node_set(html_string)
    html_fragment(html_string).css("*")
  end
end

RSpec.configure do |config|
  config.include(SpecHelpers)
end
