# Using Selenium
Wayfarer supports Selenium WebDrivers out of the box. You can execute JavaScript, take screenshots, interact with controls, and so on.

See [examples/selenium.rb](../examples/selenium.rb).
## Setup
```ruby
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
    c.connection_count = 4 # Number of instantiated WebDrivers
  end
end
```

### Selenium Grid
```ruby
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [
      :remote, url: "http://localhost:4444/wd/hub", desired_capabilities: :firefox
    ]
  end
end

DummyJob.crawl("https://example.com")
```

Inside your instance methods, you’ll have access to `#browser`, which returns a WebDriver.

## Executing JavaScript
```ruby
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
  end

  draw uri: "https://example.com"
  def example
    browser.execute_script("console.log('Hello from wayfarer!')")
  end
end

DummyJob.crawl("https://example.com")
```

## Taking screenshots
```ruby
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
    c.window_size: [1024, 768]
  end

  draw uri: "https://example.com"
  def example
    browser.save_screenshot("/tmp/screenshot.png")
  end
end

DummyJob.crawl("https://example.com")
```
