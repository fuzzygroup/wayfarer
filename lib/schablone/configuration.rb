module Schablone
  class Configuration
    DEFAULTS = {
      # Whether to print full stacktraces.
      print_stacktraces: false,

      # Whether to crash when encountering unhandled exceptions
      reraise_exceptions: false,

      # Whether URIs may be visited twice.
      allow_circulation: false,

      # Whether URIs should be normalized
      normalize_uris: false,

      # How many scraper threads to spawn in parallel
      scraper_thread_count: 6,

      # How many HTTP connections/Selenium drivers to use
      # Note: Should be >= scraper_thread_count
      connection_count: 6,

      # Which HTTP adapter to use. Supported:
      # * :net_http
      # * :selenium
      http_adapter: :net_http,

      # How long a Scraper thread may hold an adapter/Selenium driver.
      # Scrapers that exceed his limit fail with an exception.
      http_adapter_timeout: 5.0,

      # How many 3xx redirects to follow. Does not apply to Selenium drivers.
      max_http_redirects: 3,

      # Argument vector for instantiating Selenium drivers
      selenium_argv: [:firefox],

      # Which Mustermann pattern type to use when matching URI paths.
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

    def respond_to_missing?(method, private = false)
      @config.key?(method) || super
    end
  end
end
