# Schablone
A small, versatile web scraping/crawling DSL

## Installation
Install from Bundler by adding the following to your `Gemfile`:

```
gem schablone
```
Or install from RubyGems:

```
% gem install schablone
```

## Configuration
### Recognized keys and values
* __`threads`__: Number of threads to spawn.
	* Recognized values: Integers
	* Default value: `4`

* __`http_adapter`__: Which HTTP adapter to use.
	* Recognized values: `:net_http`, `:selenium`
	* Default value: `:net_http`

* __`selenium_argv`__: Argument vector passed to [`Selenium::WebDriver::for`](http://selenium.googlecode.com/git/docs/api/rb/Selenium/WebDriver.html#for-class_method).
	* Recognized values: Arrays
	* Default value: `[:firefox]`

* __`log_level`__: Which HTTP adapter to use.
	* Recognized values: [See documentation](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
	* Default value: `Logger::WARN`

* __`sanitize_node_content`__: Whether to trim leading/trailing whitespace and control characters from HTML elements' contents.
	* Recognized values: Booleans
	* Default value: `true`

* __`max_http_redirects`__: Number of HTTP redirects to follow per initial request.
	* Recognized values: Integers
	* Default value: `3`