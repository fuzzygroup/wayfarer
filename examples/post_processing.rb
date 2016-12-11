# frozen_string_literal: true
require_relative "../lib/wayfarer"

class DummyJob < Wayfarer::Job
  post_process do
    123
  end

  draw uri: "https://example.com"
  def example
    puts "Okay!"
  end
end

puts DummyJob.crawl("https://example.com")
