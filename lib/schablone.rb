require "logger"
require "ansi"

# Internals
require_relative "schablone/configuration"

# Routing
require_relative "schablone/routing/rule"
require_relative "schablone/routing/uri_rule"
require_relative "schablone/routing/host_rule"
require_relative "schablone/routing/path_rule"
require_relative "schablone/routing/query_rule"
require_relative "schablone/routing/router"

# Extraction
require_relative "schablone/extraction/extractable"
require_relative "schablone/extraction/matcher"
require_relative "schablone/extraction/evaluator"
require_relative "schablone/extraction/scraper"
require_relative "schablone/extraction/extractor"
require_relative "schablone/extraction/extractable_group"
require_relative "schablone/extraction/scoper"

# Processing
require_relative "schablone/parser"
require_relative "schablone/page"
require_relative "schablone/fetcher"
require_relative "schablone/result"
require_relative "schablone/processor"
require_relative "schablone/crawler"

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
      @logger ||= logger_instance
      @logger.level = Schablone.config.log_level
      @logger
    end

    alias_method :log, :logger

    private

    def logger_instance
      logger = Logger.new(STDOUT)
      logger.datetime_format = "%m-%d %H:%M:%S"
      logger.formatter = lambda  do |severity, datetime, _, message|
        <<-log
          #{severity} (#{datetime}):
          #{message}
        log
      end
      logger
    end
  end
end
