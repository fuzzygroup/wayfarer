# Standard library
require "logger"

# Dependencies
require "nokogiri"
require "selenium-webdriver"
require "net/http/persistent"
require "mime-types"
require "connection_pool"
require "celluloid"
require "celluloid/autostart"

# Plumbing
require_relative "schablone/configuration"

# Routing
require_relative "schablone/routing/rule"
require_relative "schablone/routing/uri_rule"
require_relative "schablone/routing/host_rule"
require_relative "schablone/routing/path_rule"
require_relative "schablone/routing/parameterized_path_rule"
require_relative "schablone/routing/query_rule"
require_relative "schablone/routing/router"

# HTTP adapters
require_relative "schablone/http_adapters/net_http_adapter"
require_relative "schablone/http_adapters/selenium_adapter"
require_relative "schablone/http_adapters/adapter_pool"

# Parsers
require_relative "schablone/parsers/xml_parser"
require_relative "schablone/parsers/json_parser"

# Processing
require_relative "schablone/task"
require_relative "schablone/scraper"
require_relative "schablone/page"
require_relative "schablone/uri_set"
require_relative "schablone/navigator"
require_relative "schablone/processor"
require_relative "schablone/crawler"

module Schablone
  VERSION = "0.0.1-alpha.1"

  class << self
    attr_writer :logger

    def logger
      @logger ||= Celluloid.logger
    end

    def config(&proc)
      @config ||= Configuration.new
      yield(@config) if block_given?
      @config
    end
  end
end
