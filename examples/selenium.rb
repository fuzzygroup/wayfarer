require_relative "../lib/wayfarer"

class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
  end

  draw uri: "https://example.com"
  def example
    browser.save_screenshot("/tmp/screenshot.png")
  end
end

DummyJob.crawl("https://example.com")
