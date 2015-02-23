require "capybara"
require "phantomjs"
require "capybara/poltergeist"

module Scrapespeare
  class HTTPClient

    attr_reader :session

    def initialize
      configure_capybara
      @session = Capybara::Session.new(Scrapespeare.config.capybara_driver)
    end

    def free
      if @session
        @session.driver.quit
        @session = nil
      end
    end

    def fetch(uri)
      @session.visit(uri)

      [
        @session.status_code,
        @session.response_headers,
        @session.html
      ]
    end

    private
    def configure_capybara
      Capybara.run_server = false
      Capybara.app_host = "about:blank"

      Capybara.register_driver(Scrapespeare.config.capybara_driver) do |app|
        Capybara::Poltergeist::Driver.new(
          app, Scrapespeare.config.capybara_opts
        )
      end
    end

  end
end
