# scrapespeare
A small web scraping library/DSL.

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
Key            | Default value | Recognized values | Description               |
-------------- | ------------- | ----------------- | ------------------------- |
`http_adapter` | `:net_http` | `:selenium` | Which HTTP adapter to use |
`selenium_argv` | `[:remote, {}]` | [See documentation](http://selenium.googlecode.com/git/docs/api/rb/Selenium/WebDriver.html#for-class_method) | Argument vector passed to `Selenium::WebDriver.for`
`strict_mode` | `true` | Boolean | Whether to raise exceptions on selector mismatch |

## Running the tests
Code is covered by an RSpec suite and Cucumber feature definitions.
Some examples require a *live* environment consisting of:

* A network connection
* [Selenium Server](https://code.google.com/p/selenium/wiki/Grid2) listening on port 4444
* [beanstalkd](http://kr.github.io/beanstalkd/) listening on port 11300

In order to run all examples including live ones, execute:

```
$ rake test:live
```

In order to run all examples excluding live ones, execute:

```
$ rake test
```

Please refer to `Rakefile` for more granular tasks.