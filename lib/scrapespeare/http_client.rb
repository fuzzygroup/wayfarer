require "capybara"
require "capybara/poltergeist"
require "phantomjs"

module Scrapespeare
  class HTTPClient

    attr_reader :session

    def initialize
      configure_capybara
      new_session
    end

    def free
      if @session
        @session.driver.quit
        @session = nil
        true
      else
        false
      end
    end

    def fetch(uri)
      @session.visit(uri)

      [
        @session.status_code,
        @session.response_headers,
        @session.html
      ]

    rescue Capybara::Poltergeist::BrowserError
      recover
      [500, {}, ""]
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

    def new_session
      @session = Capybara::Session.new(Scrapespeare.config.capybara_driver)
    end

    def recover
      free
      new_session
    end

  end
end
