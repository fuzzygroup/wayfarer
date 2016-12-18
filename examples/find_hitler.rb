# frozen_string_literal: true
require_relative "../lib/wayfarer"
require "securerandom"

class FindFoobar < Wayfarer::Job
  config.frontier = :redis_bloomfilter
  config.allow_circulation = true
  config.connection_count = 64
  config.connection_timeout = 3

  let(:counter) { 0 }

  draw host: "de.wikipedia.org"
  def site
    puts page.title
    stage page.links
  end
end

FindFoobar.perform_now("https://de.wikipedia.org/wiki/Wikipedia:Hauptseite")
