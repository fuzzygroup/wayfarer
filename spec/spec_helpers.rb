require_relative "../lib/wayfarer"

require("bundler") && Bundler.require
require "oj"

include Wayfarer
include Wayfarer::HTTPAdapters
include Wayfarer::Routing
include Wayfarer::Frontiers

Dir["./spec/shared/**/*.rb"].sort.each { |file| require file }

module SpecHelpers
  def test_app(path)
    URI("http://0.0.0.0:9876#{path}")
  end

  def fetch_page(uri)
    NetHTTPAdapter.instance.fetch(URI(uri))
  end

  def html_fragment(html)
    Nokogiri::HTML.fragment(html)
  end

  def node_set(html)
    html_fragment(html).css("*")
  end
end

RSpec.configure do |config|
  config.include(SpecHelpers)

  config.before do
    Wayfarer.config.reset!
    Wayfarer.config.selenium_argv = [:phantomjs]
  end
end
