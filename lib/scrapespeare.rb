require "logger"

require "nokogiri"
require "hashie"

$: << File.dirname(__FILE__)

# Internals
require "scrapespeare/configuration"

# Routing
require "scrapespeare/routing/rule"
require "scrapespeare/routing/uri_rule"
require "scrapespeare/routing/host_rule"
require "scrapespeare/routing/path_rule"
require "scrapespeare/routing/query_rule"
require "scrapespeare/routing/router"

# Extraction
require "scrapespeare/extraction/extractable"
require "scrapespeare/extraction/matcher"
require "scrapespeare/extraction/evaluator"
require "scrapespeare/extraction/scraper"
require "scrapespeare/extraction/extractor"
require "scrapespeare/extraction/extractable_group"
require "scrapespeare/extraction/scoper"

# Processing
require "scrapespeare/parser"
require "scrapespeare/page"
require "scrapespeare/fetcher"
require "scrapespeare/result"
require "scrapespeare/processor"
require "scrapespeare/crawler"

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
