# Shared tests
Dir["./spec/support/**/*.rb"].sort.each { |file| require file }

require("bundler") && Bundler.require
require "celluloid/test"

require "oj"

include Wayfarer
include Wayfarer::HTTPAdapters
include Wayfarer::Routing
include Wayfarer::Frontiers

Celluloid.task_class = Celluloid::Task::Threaded

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

  config.before { Celluloid.boot }
  config.after  { Celluloid.shutdown }

  config.before { Wayfarer.config.selenium_argv = [:phantomjs] }
end
