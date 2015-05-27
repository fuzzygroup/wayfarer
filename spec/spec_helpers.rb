require "bundler"
Bundler.require

# Optional dependencies (MRI-only)
unless RUBY_PLATFORM == "java"
  require "oj"
  require "pismo"
  require "mustermann"
end

include Schablone
include Schablone::HTTPAdapters
include Schablone::Extraction
include Schablone::Routing

module SpecHelpers
  def test_app(path)
    URI("http://0.0.0.0:9876#{path}")
  end

  def fetch_page(uri)
    NetHTTPAdapter.instance.fetch(URI(uri))
  end

  def html_fragment(html_str)
    Nokogiri::HTML.fragment(html_str)
  end

  def node_set(html_str)
    html_fragment(html_str).css("*")
  end

  def hide_const(const)
    cache = Object.send(:remove_const, const.to_s.to_sym)
    yield
    Object.const_set(const.to_s.to_sym, cache)
  end
end

RSpec.configure do |config|
  config.include(SpecHelpers)
end
