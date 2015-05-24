require "logger"

# Internals
require_relative "schablone/configuration"

# Routing
require_relative "schablone/routing/rule"
require_relative "schablone/routing/uri_rule"
require_relative "schablone/routing/host_rule"
require_relative "schablone/routing/path_rule"
require_relative "schablone/routing/query_rule"
require_relative "schablone/routing/route"
require_relative "schablone/routing/router"

# Extraction
require_relative "schablone/extraction/extractable"
require_relative "schablone/extraction/matcher"
require_relative "schablone/extraction/evaluator"
require_relative "schablone/extraction/scraper"
require_relative "schablone/extraction/extractor"
require_relative "schablone/extraction/extractable_group"
require_relative "schablone/extraction/scoper"

# HTTP adapters
require_relative "schablone/http_adapters/adapter_pool"
require_relative "schablone/http_adapters/net_http_adapter"
require_relative "schablone/http_adapters/selenium_adapter"

# Parsers
require_relative "schablone/parsers/xml_parser"
require_relative "schablone/parsers/json_parser"

# Processing
require_relative "schablone/worker"
require_relative "schablone/context"
require_relative "schablone/page"
require_relative "schablone/uri_set"
require_relative "schablone/navigator"
require_relative "schablone/processor"
require_relative "schablone/crawler"

module Schablone
  VERSION = "0.0.1-alpha.1"

  class << self
    def configure(&proc)
      @config ||= Configuration.new

      if block_given?
        proc.arity >= 1 ? (yield @config) : @config.instance_eval(&proc)
      else
        @config
      end
    end

    alias_method :config, :configure

    def logger
      @logger ||= Logger.new(STDOUT)
      @logger.level = Schablone.config.log_level
      @logger
    end

    alias_method :log, :logger
  end
end
