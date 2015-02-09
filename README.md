# schablone
A small web scraping toolkit suitable for recurring data extraraction tasks.

Supported features include:

* Firing HTTP requests via Net::HTTP or browser automation via [Selenium’s Ruby Bindings](https://code.google.com/p/selenium/wiki/RubyBindings)
* Support for pagination (DOM-/URI-based) and infinite scrolling
* Extraction of arbitrary data structures by leveraging CSS selectors and/or XPath expressions
* JavaScript injection: Run arbitrary code, client-side
* CLI for quickly evaluating scraping behaviour

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
For a more in-depth introduction, please see `GETTING_STARTED.md`.

## Configuration
### Runtime configuration
Runtime configuration overrides all other configuration mechanisms.

```
Schablone.config do |c|
  c.http_adapter = :net_http
end

Schablone.config.selenium_argv = [:firefox]
```

### Recognized keys and permissible values
Key            | Default value | Permissible values | Description               |
-------------- | ------------- | ----------------- | ------------------------- |
`http_adapter` | `:net_http` | `:net_http`, `:selenium`, `:phantom_js` | Which HTTP adapter to use |
`selenium_argv` | `[:remote, {}]` | [See documentation](http://selenium.googlecode.com/git/docs/api/rb/Selenium/WebDriver.html#for-class_method) | Argument vector passed to `Selenium::WebDriver.for`
`strict_mode` | `true` | Booleans | Whether to raise exceptions on selector mismatch |
`verbose` | `false` | Booleans | Whether to print more information |
`tmp_dir` | `Dir.tmpdir` | Strings | Directory for storing temporary states |
`sanitize_node_content` | `true` | Booleans | Whether to strip line-breaks, leading and trailing whitespace from HTML elements’ content |
`max_redirects` | 3 | Integers | The maximal number of HTTP redirects to follow per initial request (in order to prevent redirect loops) |

## Running the tests
Code is covered by an RSpec suite and Cucumber feature definitions.
Some examples require a *live* environment consisting of:

* A network connection
* [Selenium Server](https://code.google.com/p/selenium/wiki/Grid2) listening on port 4444 with at least 1 registered nodes
* [beanstalkd](http://kr.github.io/beanstalkd/) listening on port 11300

If you have [Foreman](https://github.com/ddollar/foreman) installed, you can execute `foreman start` to boot the environment as specified in `Procfile`.

In order to run examples *including* live ones, execute:

```
$ rake test:live
```

In order to run examples *excluding* live ones, execute:

```
$ rake test
```

Please refer to `Rakefile` for more granular tasks.