require "logger"

require "nokogiri"
require "hashie"
require "selenium-webdriver"
require "selenium/emulated_features"

$: << File.dirname(__FILE__)

require "scrapespeare/routing/rule"
require "scrapespeare/routing/uri_rule"
require "scrapespeare/routing/query_rule"
require "scrapespeare/routing/host_rule"
require "scrapespeare/routing/path_rule"
require "scrapespeare/routing/router"
require "scrapespeare/processor"
require "scrapespeare/fetcher"
require "scrapespeare/page"
require "scrapespeare/configuration"
require "scrapespeare/extractable"
require "scrapespeare/result"
require "scrapespeare/evaluator"
require "scrapespeare/matcher"
require "scrapespeare/scoper"
require "scrapespeare/extractable_group"
require "scrapespeare/extractor"
require "scrapespeare/scraper"
require "scrapespeare/crawler"
require "scrapespeare/parser"

module Scrapespeare

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
      @logger.level = Scrapespeare.config.log_level
      @logger
    end
  end

end
