---
layout: default
title: Using Capybara
categories: [Selenium]
---

# Using Capybara
When using Selenium, Wayfarer supports Selenium drivers. You can execute JavaScript, take screenshots, interact with the page, and so on. For an exhaustive list, see [the official API documentation](http://www.rubydoc.info/gems/selenium-webdriver/0.0.28/Selenium/WebDriver/Driver).

See [examples/selenium.rb](../examples/selenium.rb).

## Setup
Inside your instance methods, you have access to `#driver`, which returns a Selenium driver:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
    c.connection_count = 4 # Number of instantiated WebDrivers
  end

  draw uri: "https://example.com"
  def foo
    driver # => #<Selenium::WebDriver::Driver:...>
  end
end
{% endhighlight %}

### Selenium Grid
{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [
      :remote, url: "http://localhost:4444/wd/hub", desired_capabilities: :firefox
    ]
  end
end
{% endhighlight %}

## Executing JavaScript
```ruby
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
  end

  draw uri: "https://example.com"
  def example
    driver.execute_script("console.log('Hello from wayfarer!')")
  end
end
```

## Taking screenshots
{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
    c.window_size: [1024, 768]
  end

  draw uri: "https://example.com"
  def example
    driver.save_screenshot("/tmp/screenshot.png")
  end
end
{% endhighlight %}
