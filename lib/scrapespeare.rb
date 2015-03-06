require "nokogiri"
require "hashie"
require "selenium-webdriver"
require "selenium/emulated_features"

$: << File.dirname(__FILE__)

require "scrapespeare/core_ext/uri"

require "scrapespeare/routing/router"
require "scrapespeare/routing/rule"
require "scrapespeare/routing/rule_set"
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
require "scrapespeare/scrape_task"

module Scrapespeare

  VERSION = "0.0.1-alpha.1"

  def self.config
    @config ||= Configuration.new
    block_given? ? (yield @config) : @config
  end

end
