require_relative "../lib/wayfarer"
require "securerandom"

class FindHitler < Wayfarer::Job
  config.connection_count = 8
  config.http_adapter = :selenium
  config.selenium_argv = [:chrome]
  config.frontier = :redis
  config.reraise_exceptions = true

  draw host: "en.wikipedia.org"
  def article
    puts page.keywords
    puts "============================================"
    stage page.links
  end
end

FindHitler.perform_now("https://en.wikipedia.org/wiki/Special:Random")
