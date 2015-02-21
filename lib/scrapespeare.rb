require "ostruct"

require "nokogiri"
require "selenium-webdriver"
require "hashie"
require "thor"
require "rest-client"

$: << File.dirname(__FILE__)

require "scrapespeare/core_ext/uri"

require "scrapespeare/configuration"
require "scrapespeare/extractable"
require "scrapespeare/http_adapters/selenium_adapter"
require "scrapespeare/http_adapters/rest_client_adapter"
require "scrapespeare/evaluator"
require "scrapespeare/matcher"
require "scrapespeare/scoper"
require "scrapespeare/extractable_group"
require "scrapespeare/extractor"
require "scrapespeare/scraper"
require "scrapespeare/crawler"
require "scrapespeare/paginator"
require "scrapespeare/parser"
require "scrapespeare/uri_paginator"
require "scrapespeare/uri_iterator"
require "scrapespeare/dom_paginator"

module Scrapespeare

  VERSION = "0.0.1-alpha.1"

  def self.config
    @config ||= Configuration.new
    block_given? ? (yield @config) : @config
  end

end
