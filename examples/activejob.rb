require_relative "../lib/wayfarer"

# Prerequisites:
# 1. Run Redis: `redis-server`
# 2. Run Sidekiq: `sidekiq -r ./examples/activejob.rb`

ActiveJob::Base.queue_adapter = :sidekiq

class DummyJob < Wayfarer::Job
  config.connection_count = 16

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Hitler/
      puts "Found the dictator at #{page.uri}"
      halt
    else
      visit page.links("a")
      puts "No trace of Hitler at #{page.uri}"
    end
  end
end
