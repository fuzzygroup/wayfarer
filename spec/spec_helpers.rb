require "bundler"
Bundler.require
require "celluloid/test"

include Schablone
include Schablone::HTTPAdapters
include Schablone::Extraction
include Schablone::Routing

Celluloid.task_class = Celluloid::TaskThread

# Optional MRI-only dependencies
unless RUBY_PLATFORM == "java"
  require "oj"
  require "pismo"
  require "mustermann"
end

module SpecHelpers
  def test_app(str)
    URI("http://0.0.0.0:9876#{str}")
  end

  def fetch_page(str)
    NetHTTPAdapter.instance.fetch(URI(str))
  end

  def html_fragment(str)
    Nokogiri::HTML.fragment(str)
  end

  def node_set(str)
    html_fragment(str).css("*")
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
