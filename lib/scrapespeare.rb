require "nokogiri"
require "selenium-webdriver"
require "net/http"
require "hashie"
require "thor"

$: << File.dirname(__FILE__)

require "scrapespeare/configurable"
require "scrapespeare/extractable"
require "scrapespeare/callbacks"
require "scrapespeare/http_adapters/net_http_adapter"
require "scrapespeare/http_adapters/selenium_adapter"
require "scrapespeare/evaluator"
require "scrapespeare/matcher"
require "scrapespeare/scoper"
require "scrapespeare/extractable_group"
require "scrapespeare/extractor"
require "scrapespeare/scraper"
require "scrapespeare/crawler"
require "scrapespeare/navigator"

module Scrapespeare
  extend Configurable

  VERSION = "0.0.1-alpha.1"

  # Default configuration
  set :http_adapter, :net_http
  set :verbose, false

  def self.config
    block_given? ? (yield config) : super
  end
end
