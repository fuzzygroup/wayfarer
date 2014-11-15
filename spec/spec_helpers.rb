require "webmock/rspec"
require "scrapespeare"

module SpecHelpers

  def html_fragment(html_string)
    Nokogiri::HTML.fragment(html_string)
  end

  def node_set(html_string)
    html_fragment(html_string).css("*")
  end

end

RSpec.configure { |config| config.include(SpecHelpers) }
