# frozen_string_literal: true
require_relative "../lib/wayfarer"
require "securerandom"

Wayfarer.log.level = :debug

class FindFoobar < Wayfarer::Job
  config.frontier = :memory_bloomfilter
  config.connection_count = 32
  config.connection_timeout = 3

  draw host: //
  def site
    puts "LEL?"
    puts page.uri
    puts page.links.count
    stage page.links
  end
end

FindFoobar.perform_now("http://www.google.com")
