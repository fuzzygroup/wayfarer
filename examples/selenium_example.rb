require_relative "../lib/wayfarer"

class SeleniumExample < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
  end

  draw uri: "https://example.com"
  def example
    puts "YUP"
    driver.execute_script("console.log('Hello from wayfarer!')")
    driver.save_screenshot("/tmp/screenshot.png")
  end
end

Wayfarer.log.level = 923743287489

SeleniumExample.perform_now("https://example.com")
