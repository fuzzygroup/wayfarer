require "webmock/rspec"
require "scrapespeare"

module SpecHelpers

  def dummy_html(file_name)
    IO.read(
      File.expand_path("../../support/www/#{file_name}", __FILE__)
    )
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
  config.before { WebMock.disable_net_connect!(allow_localhost: true) }
end
