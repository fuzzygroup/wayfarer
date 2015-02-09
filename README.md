# schablone
A small web scraping toolkit suitable for recurring data extraraction tasks.

Supported features include:

* Firing of HTTP requests via Net::HTTP or browser automation via [Selenium’s Ruby Bindings](https://code.google.com/p/selenium/wiki/RubyBindings)
* Support for pagination (DOM-/URI-based) and infinite scrolling
* Extraction of arbitrary data structures by leveraging CSS selectors and/or XPath expressions

## Installation
Install from Bundler by adding the following to your `Gemfile`:

```
gem scrapespeare
```
Or install from RubyGems:

```
$ gem install scrapespeare
```

## Usage example

```
crawler = Scrapespeare::Crawler.new do
end
```

## Configuration
### Keys and default values
Key            | Default value | Recognized values | Description               |
-------------- | ------------- | ----------------- | ------------------------- |
`http_adapter` | `:net_http` | `:net_http`, `:selenium`, `phantom_js` | Which HTTP adapter to use |
`selenium_argv` | `[:remote, {}]` | [See documentation](http://selenium.googlecode.com/git/docs/api/rb/Selenium/WebDriver.html#for-class_method) | Argument vector passed to `Selenium::WebDriver.for`
`strict_mode` | `true` | Booleans | Whether to raise exceptions on selector mismatch |
`verbose` | `false` | Booleans | Whether to print additional state information |
`tmp_dir` | `Dir.tmpdir` | Strings | Directory for storing temporary states |

### Runtime configuration
Runtime configuration overrides all other configuration mechanisms.

```
Schablone.config do |config|
  config.http_adapter = :net_http
end

# Alternatively:
Schablone.config.selenium_argv = [:firefox]
```

## Command-line interface


## Running the tests
Code is covered by an RSpec suite and Cucumber feature definitions.
Some examples require a *live* environment consisting of:

* A network connection
* [Selenium Server](https://code.google.com/p/selenium/wiki/Grid2) listening on port 4444 with at least 1 registered nodes
* [beanstalkd](http://kr.github.io/beanstalkd/) listening on port 11300

Once you have the dependencies for a live environment installed, you can install [Foreman](https://github.com/ddollar/foreman) and execute:

```
foreman start
```

In order to run all examples including live ones, execute:

```
$ rake test:live
```

In order to run all examples excluding live ones, execute:

```
$ rake test
```

Please refer to `Rakefile` for more granular tasks.