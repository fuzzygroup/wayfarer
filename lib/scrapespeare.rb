require "nokogiri"
require "hashie"
require "selenium-webdriver"
require "selenium/emulated_features"

$: << File.dirname(__FILE__)

require "scrapespeare/core_ext/uri"

require "scrapespeare/http_adapters/net_http_adapter"

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

require "scrapespeare/dom_paginator"
require "scrapespeare/uri_iterator"

module Scrapespeare

  VERSION = "0.0.1-alpha.1"

  def self.config
    @config ||= Configuration.new
    block_given? ? (yield @config) : @config
  end

end
