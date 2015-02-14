require "webmock/cucumber"
require_relative "../../lib/scrapespeare"

module FeatureHelpers

  def example_html(file_name)
    file_path = File.join(
      File.dirname(__FILE__), "../../examples/www/#{file_name}"
    )
    IO.read(file_path)
  end

end

World(FeatureHelpers)
