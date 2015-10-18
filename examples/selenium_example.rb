require_relative "../lib/wayfarer"

Wayfarer.log.level = Logger::DEBUG

class SeleniumExample < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
  end

  puts Wayfarer.config.http_adapter

  draw uri: "https://google.com"
  def example
    driver.execute_script("console.log('Hello from wayfarer!')")
    driver.save_screenshot("/tmp/screenshot.png")
  end
end

# DummyJob.crawl("https://example.com")
