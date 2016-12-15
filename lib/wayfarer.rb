# frozen_string_literal: true
# rubocop:disable Style/Documentation
require "logger"
require "uri"

# Plumbing
require_relative "wayfarer/configuration"

# Routing
require_relative "wayfarer/routing/rule"
require_relative "wayfarer/routing/uri_rule"
require_relative "wayfarer/routing/host_rule"
require_relative "wayfarer/routing/path_rule"
require_relative "wayfarer/routing/query_rule"
require_relative "wayfarer/routing/router"

# Networking
require_relative "wayfarer/http_adapters/net_http_adapter"
require_relative "wayfarer/http_adapters/selenium_adapter"
require_relative "wayfarer/http_adapters/adapter_pool"

# Parsers
require_relative "wayfarer/parsers/xml_parser"
require_relative "wayfarer/parsers/json_parser"

# Frontiers
require_relative "wayfarer/frontiers/memory_frontier"
require_relative "wayfarer/frontiers/redis_frontier"

# Processing
require_relative "wayfarer/locals"
require_relative "wayfarer/job"
require_relative "wayfarer/finders"
require_relative "wayfarer/page"
require_relative "wayfarer/uri_set"
require_relative "wayfarer/processor"

# CLI
require_relative "wayfarer/util/progress_bar"

module Wayfarer
  VERSION = "0.0.0"

  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    alias log logger

    def config
      @config ||= Configuration.new
      yield(@config) if block_given?
      @config
    end
  end
end

# Don't buffer writes to stdout
STDOUT.sync = true

# Don't print debug messages by default
Wayfarer.log.level = 1
