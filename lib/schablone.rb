require "logger"

require "nokogiri"
require "hashie"

$: << File.dirname(__FILE__)

# Internals
require "schablone/configuration"

# Routing
require "schablone/routing/rule"
require "schablone/routing/uri_rule"
require "schablone/routing/host_rule"
require "schablone/routing/path_rule"
require "schablone/routing/query_rule"
require "schablone/routing/router"

# Extraction
require "schablone/extraction/extractable"
require "schablone/extraction/matcher"
require "schablone/extraction/evaluator"
require "schablone/extraction/scraper"
require "schablone/extraction/extractor"
require "schablone/extraction/extractable_group"
require "schablone/extraction/scoper"

# Processing
require "schablone/parser"
require "schablone/page"
require "schablone/fetcher"
require "schablone/result"
require "schablone/processor"
require "schablone/crawler"

module Schablone

  VERSION = "0.0.1-alpha.1"

  class << self
    def configure(&proc)
      @config ||= Configuration.new

      if block_given?
        proc.arity == 1 ? (yield @config) : @config.instance_eval(&proc)
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
  end

end
