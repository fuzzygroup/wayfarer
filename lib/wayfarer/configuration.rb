# frozen_string_literal: true
require "ostruct"
require "securerandom"

module Wayfarer
  class Configuration < OpenStruct
    DEFAULTS = {
      # Print full stacktraces?
      print_stacktraces: true,

      # Crash when encountering unhandled exceptions?
      reraise_exceptions: false,

      # Allow processing URIs multiple times?
      allow_circulation: false,

      # How many HTTP connections/Selenium drivers to use
      connection_count: 4,

      # Which HTTP adapter to use. Supported are :net_http and :selenium
      http_adapter: :net_http,

      # Which frontier to use. Supported are :memory and :redis
      frontier: :memory,

      # How long a thread may hold an HTP adapter.
      # Threads that exceed this limit fail with an exception.
      connection_timeout: Float::INFINITY,

      # How many 3xx redirects to follow. Has no effect when using Selenium
      max_http_redirects: 3,

      # Argument vector for instantiating Selenium drivers
      selenium_argv: [:firefox],

      # Argument vector for instantiating a Redis connection
      redis_opts: {
        host: "localhost",
        port: 6379
      },

      # Size of browser windows
      window_size: [1024, 768],

      # Which Mustermann pattern type to use when matching URI paths
      mustermann_type: :sinatra,

      # Argument vector for instantiating Bloomfilters
      bloomfilter_opts: {
        size: 100,
        hashes: 2,
        seed: 1,
        bucket: 3,
        raise: false
      }
    }.freeze

    attr_reader :uuid

    def initialize(overrides = {})
      super(DEFAULTS.merge(overrides))
      @uuid = SecureRandom.uuid
    end

    def reset!
      DEFAULTS.each { |key, val| self[key] = val }
    end
  end
end
