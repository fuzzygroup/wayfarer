# schablone
A small web scraping library built for recurring data extraction tasks.

Features include:

* Pagination

## Installation
Install from Bundler by adding the following to your `Gemfile`:

```
gem scrapespeare
```
Or install from RubyGems:

```
$ gem install scrapespeare
```

## Example
DSL:

```
Schablone::Crawler.new do

  configure do
    verbose = true
  end

  scrape do
    css :title, "h1"
    css :languages, ".language"
  end

  evaluate :rating do |nodes|
    
  end

  paginate_uri param: "page"
  paginate_uri param: "page", from: 6, to: 12, step: 3
  paginate_uri param: "page", range: 0..10

  paginate_uri fragment: "page"

  paginate_dom css: "a.next-page"

  paginate do |env|
    env.http_adapter
  end

end
```

Programmatic:

```
crawler = Schablone::Crawler.new
crawler.config.verbose = true
crawler.scrape do

end
```


## Configuration
### Global configuration
```
Schablone.configure do |config|
  config.http_adapter = :net_http
end

Schablone.configure do
  http_adapter = :net_http
end

Schablone.config.http_adapter = :net_http
```
### Instance configuration

### Recognized keys and values
Key            | Default value | Recognized values | Description               |
-------------- | ------------- | ----------------- | ------------------------- |
`http_adapter` | `:faraday` | `:faraday`, `:selenium` | Which HTTP adapter to use |
`selenium_argv` | `[:firefox, {}]` | [See documentation](http://selenium.googlecode.com/git/docs/api/rb/Selenium/WebDriver.html#for-class_method) | Argument vector passed to `Selenium::WebDriver.for`
`strict_mode` | `true` | Booleans | Whether to raise exceptions on selector mismatch |
`verbose` | `false` | Booleans | Whether to print more information |
`tmp_dir` | `Dir.tmpdir` | Strings | Directory for storing temporary states |
`sanitize_node_content?` | `true` | Booleans | Whether to strip line-breaks, leading and trailing whitespace from HTML elements’ content |
`max_redirects` | 3 | Integers | The maximal number of HTTP redirects to follow per initial request (in order to prevent redirect loops) |
`http_agent` | `"Schablone"` | Strings | The HTTP agent string to send |
`emulate_headers` | `false` | Booleans | The HTTP agent string to send |

## Testing
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

For more granular tasks, please refer to `Rakefile`.