require("bundler") && Bundler.require
require "celluloid/test"

include Wayfarer
include Wayfarer::HTTPAdapters
include Wayfarer::Routing

Celluloid.task_class = Celluloid::TaskThread

# Optional MRI-only dependencies
unless RUBY_PLATFORM == "java"
  require "oj"
  require "pismo"
  require "mustermann"
end

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

  def hide_const(const)
    sym = const.to_s.to_sym
    cache = Object.send(:remove_const, sym)
    yield
    Object.const_set(sym, cache)
  end
end

RSpec.configure do |config|
  config.include(SpecHelpers)

  config.before { Celluloid.boot }
  config.after  { Celluloid.shutdown }
end
