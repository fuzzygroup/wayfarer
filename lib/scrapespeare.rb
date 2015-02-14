require "ostruct"

require "nokogiri"
require "selenium-webdriver"
require "net/http"
require "hashie"
require "thor"

$: << File.dirname(__FILE__)

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
require "scrapespeare/paginator"

module Scrapespeare
  extend self

  VERSION = "0.0.1-alpha.1"

  def config
    @config ||= OpenStruct.new(defaults)
  end

  private
  def defaults
    {
      http_adapter: :net_http,
      verbose: false
    }
  end
end
