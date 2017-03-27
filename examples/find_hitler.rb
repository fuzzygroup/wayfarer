require_relative "../lib/wayfarer"
require "securerandom"

class FindHitler < Wayfarer::Job
  config.connection_count = 12
  config.http_adapter = :selenium
  config.selenium_argv = [:chrome]
  config.reraise_exceptions = true

  draw host: /./
  def article
    puts page.keywords
    puts "============================================"
    stage page.links
  end
end

FindHitler.perform_now("https://www.google.de/#q=that+is+funny")
