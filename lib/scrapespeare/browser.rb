require "phantomjs"
require "capybara"
require "capybara/poltergeist"

module Scrapespeare
  class Browser

    attr_reader :session

    def initialize
      Selenium::WebDriver::PhantomJS.path = Phantomjs.path

      Capybara.run_server = false
      Capybara.app_host = "about:blank"
      Capybara.default_driver = :poltergeist

      @session = Capybara::Session.new(:poltergeist)
    end

  end
end
