require "ostruct"

module Wayfarer
  class Configuration < OpenStruct
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

      # Which frontier to use. Supported are :memory and :redis
      frontier: :memory,

      # How long a Scraper thread may hold an adapter.
      # Scrapers that exceed his limit fail with an exception.
      connection_timeout: 5.0,

      # How many 3xx redirects to follow. Has no effect when using Selenium
      max_http_redirects: 3,

      # Argument vector for instantiating Selenium drivers
      selenium_argv: [:firefox],

      # Argument vector for instantiating a Redis connection
      redis_argv: [],

      # Size of browser windows
      window_size: [1024, 768],

      # Which Mustermann pattern type to use when matching URI paths
      mustermann_type: :sinatra
    }

    def initialize
      super(DEFAULTS)
    end

    def reset!
      DEFAULTS.each { |key, val| self[key] = val }
    end
  end
end
