# Schablone
A versatile web crawling/scraping library

## Features
* Fires HTTP requests via [net-http-persistent](https://github.com/drbrain/net-http-persistent) or automates JavaScript-enabled browsers with [Selenium](https://github.com/seleniumhq/selenium), e.g. [PhantomJS](http://phantomjs.org)
* Parses HTML/XML with [Nokogiri](http://nokogiri.org) and JSON with `::JSON` or [oj](https://github.com/ohler55/oj)
* Ships with an optional data extraction DSL based on CSS/XPath
* Traverses page graphs non-circular, breadth-first and multithreaded
* Is agnostic about data storages

## Installation
Install with Bundler by adding the following line to your `Gemfile`:

```
gem schablone
```
Or install via RubyGems:

```
% gem install schablone
```

## Example
```
crawler = Schablone::Crawler.new do
  handle :index do
    visit page.links
  end

  handle :issues do
    visit page.links
  end
end
```
For more, see [`examples/`](http://google.com) or read [`GETTING_STARTED.md`](http://google.com).


## Configuration
### Recognized keys and values
* __`threads`__: Number of threads to spawn.
	* Recognized values: Integers
	* Default value: `4`

* __`http_adapter`__: Which HTTP adapter to use.
	* Recognized values: `:net_http`, `:selenium`
	* Default value: `:net_http`

* __`selenium_argv`__: Argument vector passed to [`Selenium::WebDriver::for`](http://selenium.googlecode.com/git/docs/api/rb/Selenium/WebDriver.html#for-class_method).
	* Recognized values: [See documentation](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
	* Default value: `[:firefox]`

* __`log_level`__: Minimum level of log messages to print.
	* Recognized values: [See documentation](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
	* Default value: `Logger::WARN`

* __`sanitize_node_content`__: Whether to trim leading/trailing whitespace and control characters from inner HTML/XML.
	* Recognized values: Booleans
	* Default value: `true`
	* __NOTE__: Only applies if you’re using the data extraction DSL.

* __`ignore_fragment_identifiers`__: Whether to treat URIs with only differing fragment identifiers as equal.
	* Recognized values: Booleans
	* Default value: `true`

* __`max_http_redirects`__: Number of HTTP redirects to follow per initial request.
	* Recognized values: Integers
	* Default value: `3`
	* __NOTE__: Has no effect if you’re using Selenium.

### Using [oj](https://github.com/ohler55/oj) instead of `::JSON`
If oj is 

```ruby
require "oj"

# Set parsing options as desired
Oj.default_options = { mode: :compat }
```

### Setting [Nokogiri](https://github.com/ohler55/oj)’s parsing options