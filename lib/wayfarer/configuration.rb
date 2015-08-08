module Wayfarer
  class Configuration
    DEFAULTS = {
      # Whether to print full stacktraces
      print_stacktraces: false,

      # Whether to crash when encountering unhandled exceptions in actors
      reraise_exceptions: false,

      # Whether URIs may be visited twice
      allow_circulation: false,

      # Whether trailing slashes and fragment identifiers should be ignored
      normalize_uris: true,

      # How many HTTP connections/Selenium drivers to use
      # Should be >= scraper_thread_count
      connection_count: 4,

      # Which HTTP adapter to use. Supported are :net_http and :selenium
      http_adapter: :net_http,

      # How long a Scraper thread may hold an adapter/Selenium driver.
      # Scrapers that exceed his limit fail with an exception.
      connection_timeout: 5.0,

      # How many 3xx redirects to follow. Does not apply to Selenium drivers
      max_http_redirects: 3,

      # Argument vector for instantiating Selenium drivers
      selenium_argv: [:firefox],

      # Size of browser windows (screenshots)
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

    def respond_to_missing?(method, private = false)
      @config.key?(method) || super
    end
  end
end
