require "nokogiri"
require "selenium-webdriver"
require "net/http"

$: << File.dirname(__FILE__)
require "scrapespeare/configurable"
require "scrapespeare/http_adapters/net_http_adapter"
require "scrapespeare/http_adapters/selenium_adapter"
require "scrapespeare/evaluator"
require "scrapespeare/extractor"
require "scrapespeare/scraper"

module Scrapespeare
  VERSION = "0.0.1-alpha"
end
