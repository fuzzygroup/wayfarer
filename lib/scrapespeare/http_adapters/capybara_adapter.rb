require "capybara"
require "phantomjs"
require "capybara/poltergeist"

module Scrapespeare
  module HTTPAdapters
    class CapybaraAdapter

      attr_reader :session

      def initialize
        configure_capybara
        @session = Capybara::Session.new(:poltergeist)
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
        Capybara.register_driver :poltergeist do |app|
          Capybara::Poltergeist::Driver.new(app, phantomjs: Phantomjs.path)
        end
      end

    end
  end
end
