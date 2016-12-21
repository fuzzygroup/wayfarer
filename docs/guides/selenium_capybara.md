---
layout: default
title: Selenium & Capybara
categories: [Basics]
---

# Selenium & Capybara

[Selenium](http://www.seleniumhq.org) is a browser automation framework. [Capybara](https://github.com/teamcapybara/capybara) is an acceptance testing framework that puts an expressive DSL on Selenium's WebDrivers. Both are first-class citizens in Wayfarer and the best tools for automating browsers.

## Selenium WebDrivers

WebDrivers let you remote-control browsers, e.g. Firefox, Chrome, Safari and PhantomJS.

Depending on what browser you want to automate, you have to install and run the corresponding driver first. For installation instructions, see the project websites:

* Firefox: [geckodriver](https://github.com/mozilla/geckodriver)
* Chrome: [chromedriver](https://sites.google.com/a/chromium.org/chromedriver)
* Safari: [SafariDriver](https://github.com/SeleniumHQ/selenium/wiki/SafariDriver)
* PhantomJS ships with an embedded driver.

Other browsers are supported, too. For an exhaustive list, see the "Third Party Drivers, Bindings, and Plugins" section on the [Selenium downloads page](http://www.seleniumhq.org/download).

If you want to run browser processes on a central server, consider using [Selenium Grid](http://www.seleniumhq.org/projects/grid).

Wayfarer hides the details of managing Ruby driver objects from you. In order to use Selenium, set the `http_adapter` configuration key to `:selenium`. Pass in the desired browser and arguments by setting the `selenium_argv` key. The number of browser processes can be controlled with the `connection_count` key.

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config do |c|
    # Use 4 Firefox processes
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
    c.connection_count = 4

    # Chrome
    # c.selenium_argv = [:chrome]

    # Safari
    # c.selenium_argv = [:safari]

    # PhantomJS
    # c.selenium_argv = [:phantomjs]

    # Selenium Grid
    # c.selenium_argv = [
    #   :remote,
    #   url: "http://localhost:4444/wd/hub",
    #   desired_capabilities: :firefox
    # ]
  end
end
{% endhighlight %}

<aside class="note">
In order to avoid redirect loops, the <code>:net_http</code> adapter supports the <code>max_http_redirects</code> configuration key. Because redirects are opaque to WebDrivers, the configuration key does not apply to the Selenium adapter. See <a href="configuration.html">Configuration</a>.
</aside>

### Accessing the WebDriver

Within actions, `#driver` returns a [`Selenium::WebDriver::Driver`](http://www.rubydoc.info/gems/selenium-webdriver/Selenium/WebDriver/Driver):

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
  end

  draw uri: "https://example.com"
  def example
    driver # => #<Selenium::WebDriver::Driver:...>
  end
end
{% endhighlight %}

<aside class="note">
What you do with a WebDriver is opaque to Wayfarer. If you handle navigation yourself with a WebDriver and bypass the <a href="/guides/frontiers.html">frontier</a>, Wayfarer cannot ensure you don't visit URIs twice.
</aside>

## Capybara

When using the `:selenium` HTTP adapter, `#browser` returns a [`Capybara::Selenium::Driver`](http://www.rubydoc.info/github/jnicklas/capybara/Capybara/Selenium/Driver) within actions:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config do |c|
    c.http_adapter = :selenium
    c.selenium_argv = [:firefox]
  end

  draw uri: "https://example.com"
  def example
    browser # => #<Capybara::Selenium::Driver:...>
  end
end
{% endhighlight %}

<aside class="note">
What you do with a WebDriver is opaque to Wayfarer. If you handle navigation yourself with a WebDriver and bypass the <a href="/guides/frontiers.html">frontier</a>, Wayfarer cannot ensure you don't visit URIs twice.
</aside>
