require "webmock/cucumber"
require "aruba/cucumber"
require "scrapespeare"

module FeatureHelpers

  def html(file_name)
    File.read(
      File.join(File.dirname(__FILE__), "www/#{file_name}")
    )
  end

end

World(FeatureHelpers)
