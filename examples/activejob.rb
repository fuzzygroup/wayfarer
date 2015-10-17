require_relative "../lib/wayfarer"

# Requirements:
# 1. Run Sidekiq: `sidekiq -r ./examples/activejob.rb`
# 2.

class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    puts "Okay!"
  end
end

DummyJob.perform_later("https://example.com")
