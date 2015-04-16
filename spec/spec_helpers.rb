require "schablone"

include Schablone
include Schablone::Extraction
include Schablone::Routing

module SpecHelpers
  def test_app(path)
    URI("http://0.0.0.0:9876#{path}")
  end

  def fetch_page(uri)
    Fetcher.new.fetch(URI(uri))
  end

  def queue(array)
    array.inject(Queue.new) { |queue, elem| queue << elem }
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
