require_relative "../lib/wayfarer"

class SeleniumExample < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
  end

  draw uri: "https://google.com"
  def example
    driver.execute_script("console.log('Hello from wayfarer!')")
    driver.save_screenshot("/tmp/screenshot.png")

    browser.click_link "Auf gut Glück!"
  end
end

# DummyJob.crawl("https://example.com")
