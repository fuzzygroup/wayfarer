# TODO: OpenStructs break on JRuby?
module Wayfarer
  class Configuration
    DEFAULTS = {
      # Print full stacktraces?
      print_stacktraces: true,

      # Crash when encountering unhandled exceptions?
      reraise_exceptions: false,

      # Allow processing URIs multiple times?
      allow_circulation: false,

      # Whether trailing slashes and fragment identifiers should be considered insignificant when comparing URIs
      normalize_uris: true,

      # How many HTTP connections/Selenium drivers to use
      connection_count: 4,

      # Which HTTP adapter to use. Supported are :net_http and :selenium
      http_adapter: :net_http,

      # How long a Scraper thread may hold an adapter.
      # Scrapers that exceed his limit fail with an exception.
      connection_timeout: 5.0,

      # How many 3xx redirects to follow. Has no effect when using Selenium
      max_http_redirects: 3,

      # Argument vector for instantiating Selenium drivers
      selenium_argv: [:firefox],

      # Size of browser windows
      window_size: [1024, 768],

      # Which Mustermann pattern type to use when matching URI paths
      mustermann_type: :sinatra
    }

    def initialize
      @config = {}
      reset!
    end

    def reset!
      @config.replace(DEFAULTS)
    end

    private

    def method_missing(method, *args)
      if method.to_s =~ /^\w+=$/
        @config[method.to_s.chomp("=").to_sym] = args.first
      else
        @config[method]
      end
    end

    # TODO: Does not include writers
    def respond_to_missing?(method, private = false)
      @config.key?(method) || super
    end
  end
end
