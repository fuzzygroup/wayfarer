# Standard library
require "logger"

# Dependencies
require "nokogiri"
require "selenium-webdriver"
require "net/http/persistent"
require "mime-types"
require "celluloid"
require "celluloid/autostart"

# Plumbing
require_relative "wayfarer/configuration"

# Routing
require_relative "wayfarer/routing/rule"
require_relative "wayfarer/routing/uri_rule"
require_relative "wayfarer/routing/host_rule"
require_relative "wayfarer/routing/path_rule"
require_relative "wayfarer/routing/parameterized_path_rule"
require_relative "wayfarer/routing/query_rule"
require_relative "wayfarer/routing/router"

# HTTP adapters
require_relative "wayfarer/http_adapters/net_http_adapter"
require_relative "wayfarer/http_adapters/selenium_adapter"
require_relative "wayfarer/http_adapters/adapter_pool"

# Parsers
require_relative "wayfarer/parsers/xml_parser"
require_relative "wayfarer/parsers/json_parser"

# Processing
require_relative "wayfarer/task"
require_relative "wayfarer/scraper"
require_relative "wayfarer/page"
require_relative "wayfarer/normalized_uri_set"
require_relative "wayfarer/navigator"
require_relative "wayfarer/processor"
require_relative "wayfarer/crawler"

module Wayfarer
  VERSION = "0.0.1"

  class << self
    attr_writer :logger

    def logger
      @logger || Celluloid.logger
    end

    alias_method :log, :logger

    def config(&proc)
      @config ||= Configuration.new
      yield(@config) if block_given?
      @config
    end
  end
end
