require_relative "../lib/wayfarer"

class MyJob < Wayfarer::Job
  config do |config|
    config.http_adapter = :selenium
    config.selenium_argv = [:firefox]
    config.connection_count = 2
    config.reraise_exceptions = true
    config.print_stacktraces = true
  end

  router.draw :article, host: /wikipedia/

  post_process :collect

  def self.collect
    puts "IM SO RUNNING."
  end

  def article
    timestamp = Time.now.to_i
    browser.save_screenshot("/Users/dom/Desktop/screenshots/#{timestamp}.png")
    puts "I'm here: #{page.uri}"
    visit page.links "a"
  end
end

puts MyJob.crawl("http://wikipedia.org")
