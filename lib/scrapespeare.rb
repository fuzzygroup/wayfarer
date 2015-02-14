require "ostruct"

require "nokogiri"
require "selenium-webdriver"
require "faraday"
require "hashie"
require "thor"

$: << File.dirname(__FILE__)

require "scrapespeare/configuration"
require "scrapespeare/extractable"
require "scrapespeare/callbacks"
require "scrapespeare/http_adapters/selenium_adapter"
require "scrapespeare/http_adapters/faraday_adapter"
require "scrapespeare/evaluator"
require "scrapespeare/matcher"
require "scrapespeare/scoper"
require "scrapespeare/extractable_group"
require "scrapespeare/extractor"
require "scrapespeare/scraper"
require "scrapespeare/crawler"
require "scrapespeare/paginator"
require "scrapespeare/dom_paginator"
require "scrapespeare/uri_constructor"
require "scrapespeare/interactive_paginator"

module Scrapespeare

  VERSION = "0.0.1-alpha.1"

  def self.config
    @config ||= Configuration.new
    block_given? ? (yield @config) : @config
  end

  def self.[](uri, &proc)
    crawler = Crawler.new
    crawler.instance_eval(proc) if block_given?
    crawler.crawl(uri)
  end

end
