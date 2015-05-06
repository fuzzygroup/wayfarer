# Robber
A versatile yet small web crawling/scraping framework, batteries included.

[__API documentation__](https://github.com/bauerd/schablone)

## Features
* Fires HTTP requests via [net-http-persistent](https://github.com/drbrain/net-http-persistent) or automates JavaScript-enabled browsers with [Selenium](https://github.com/seleniumhq/selenium), e.g. [PhantomJS](http://phantomjs.org)
* Ensures non-circular, breadth-first and multithreaded traversal of page graphs
* Parses HTML/XML with [Nokogiri](http://nokogiri.org) and JSON with `::JSON` or [oj](https://github.com/ohler55/oj)
* Simplifies data extraction with an optional DSL based on CSS/XPath
* Extracts meta-data with [Pismo](https://github.com/peterc/pismo) when needed
* Ships with [RSpec](http://rspec.info/) matchers for testing crawling behaviour
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

## Usage example
```
crawler = Schablone::Crawler.new do
  scrape :index do
    visit page.links
  end

  scrape :issues do
    visit page.links
  end
end
```
For more, see [`examples/`](http://google.com) or read [`GETTING_STARTED.md`](http://google.com).


## Configuration
### Recognized keys and values
* __`threads`__

	Number of threads to spawn.
	* Recognized values: Integers
	* Default value: `4`

* __`http_adapter`__

	Which HTTP adapter to use.
	* Recognized values: `:net_http`, `:selenium`
	* Default value: `:net_http`

* __`selenium_argv`__

	Argument vector passed to `Selenium::WebDriver::for`.
	* Recognized values: [See documentation](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
	* Default value: `[:firefox]`

* __`log_level`__

	Minimum level of log messages to print.
	* Recognized values: [See documentation](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
	* Default value: `Logger::WARN`

* __`sanitize_node_content`__

	Whether to trim leading/trailing whitespace and control characters from inner HTML/XML.
	* Recognized values: Booleans
	* Default value: `true`
	* __NOTE__: Only applies if you’re using `Schablone::Extraction`.

* __`ignore_fragment_identifiers`__

	Whether to treat URIs with only differing fragment identifiers as equal.
	* Recognized values: Booleans
	* Default value: `true`

* __`max_http_redirects`__

	Number of HTTP redirects to follow per initial request.
	* Recognized values: Integers
	* Default value: `3`
	* __NOTE__: Has no effect if you’re using Selenium.

* __`nokogiri_parsing_options`__

	A Proc that gets bound when calling `Nokogiri::HTML`/`Nokogiri::XML`
	* Recognized values: Procs, [see documentation](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/ParseOptions)
	* Default value: `-> (config) {}`

* __`oj_parsing_options`__

	A `Hash` that gets passed to `Oj::load`
	* Recognized values: Hashes, [see documentation](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/ParseOptions)
	* Default value: `{}`

* __`mustermann_pattern_type`__

	Which pattern type to use when matching URIs.
	* Recognized values: Symbols, [see documentation](https://github.com/rkh/mustermann#pattern-types)
	* Default value: `:template`
	* __NOTE__: You might have to install the corresponding pattern type gems.

### Using oj instead of `::JSON`
oj provides better performance than the standard library’s `JSON` module. Due to it being a C extension, it is not listed as a dependency. In order to use oj, [install](https://github.com/ohler55/oj#installation) and `require "oj"`. It gets picked up automatically.

```ruby
require "oj"

crawler = Schablone::Crawler.new # JSON now gets parsed with oj
```

## Caveats and shortcomings
* PhantomJS is highly recommended when using Selenium. In contrast to most other WebDrivers, it implements `#response_code` and `#response_headers`.
