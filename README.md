# Robber
A versatile web crawling/scraping framework for MRI and JRuby

## Features
* Fires HTTP requests via [net-http-persistent](https://github.com/drbrain/net-http-persistent) or automates JavaScript-enabled browsers with [Selenium](https://github.com/seleniumhq/selenium), e.g. [PhantomJS](http://phantomjs.org)
* Ensures non-circular, breadth-first and multithreaded traversal of page graphs
* Parses HTML/XML with [Nokogiri](http://nokogiri.org) and JSON with `::JSON` or [oj](https://github.com/ohler55/oj)
* Simplifies data extraction with an optional DSL based on CSS/XPath
* Extracts meta-data with [Pismo](https://github.com/peterc/pismo) if needed
* Obeys `robots.txt` if you want it to
* Integreates seamlessly with Rails’ ActiveJob
* Is agnostic about data storage

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
Options can be set as follows:

```ruby
Schablone.config.key = value

Schablone.config do
  key = value
end

Schablone::Crawler.new do
  config.key = value
  config { |c| c.key = value }
  config { key = value }
end
```

### Recognized keys and values
* __`threads`__

	Number of threads to spawn.
	* Recognized values: Integers
	* Default value: `4`

* __`user_agent`__

	Number of threads to spawn.
	* Recognized values: Strings
	* Default value: `"Schablone"`

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
	* Note: You can bring your own logger with `Schablone::logger=`

* __`sanitize_node_content`__

	Whether to trim leading/trailing whitespace and control characters from inner HTML/XML.
	* Recognized values: Booleans
	* Default value: `true`
	* Note: Only applies when using `Schablone::Extraction`.

* __`ignore_fragment_identifiers`__

	Whether to treat URIs with only differing fragment identifiers as equal.
	* Recognized values: Booleans
	* Default value: `true`

* __`max_http_redirects`__

	Number of HTTP redirects to follow per initial request.
	* Recognized values: Integers
	* Default value: `3`
	* Note: Has no effect when using Selenium.

* __`obey_robots_txt`__

	Whether to obey `robots.txt`.
	* Recognized values: Booleans
	* Default value: `false`

* __`nokogiri_parsing_options`__

	A Proc that gets bound when calling `Nokogiri::HTML`/`Nokogiri::XML` and is passed an instance of `Nokogiri::XML::ParseOptions`.
	* Recognized values: Procs, [see documentation](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/ParseOptions)
	* Default value: `-> (config) {}`
	
* __`oj_parsing_options`__

	A `Hash` that gets passed to `Oj::load`
	* Recognized values: Hashes, [see documentation](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/ParseOptions)
	* Default value: `{}`

* __`mustermann_pattern_type`__

	Which pattern type to use when matching URI paths.
	* Recognized values: Symbols, [see documentation](https://github.com/rkh/mustermann#pattern-types)
	* Default value: `:template`
	* Note: You might have to install the corresponding Mustermann gems.

### Using oj instead of `::JSON`
oj provides better performance than the standard library’s `JSON` module. Due to it being a C extension, it is not listed as a dependency. In order to use oj, [install](https://github.com/ohler55/oj#installation) and `require "oj"`. It gets picked up automatically.

### Using Mustermann
oj provides better performance than the standard library’s `JSON` module. Due to it being a C extension, it is not listed as a dependency. In order to use oj, [install](https://github.com/ohler55/oj#installation) and `require "oj"`. It gets picked up automatically.

### Using Pismo
oj provides better performance than the standard library’s `JSON` module. Due to it being a C extension, it is not listed as a dependency. In order to use oj, [install](https://github.com/ohler55/oj#installation) and `require "oj"`. It gets picked up automatically.
