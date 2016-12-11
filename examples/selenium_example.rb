require_relative "../lib/wayfarer"

class SeleniumExample < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
  end

  draw uri: "https://example.com"
  def example
    puts "YUP"
    driver.execute_script("console.log('Hello from wayfarer!')")
    driver.save_screenshot("/tmp/screenshot.png")
  end
end

SeleniumExample.perform_now("https://example.com")

Wayfarer.log.level = -1
