# Wayfarer
[![Build Status](https://travis-ci.org/bauerd/wayfarer.svg)](https://travis-ci.org/bauerd/wayfarer)

Versatile web crawling with Ruby

* [__Getting started__]()
* [__GitHub wiki__]()
* [__Code examples__]()
* [__API documentation__]()
* [__Issue tracker__]()

## Features
* Non-circular, breadth-first and multithreaded traversal of page graphs
* Fires HTTP requests via [net-http-persistent](https://github.com/drbrain/net-http-persistent) or automates browsers with [Selenium](https://github.com/seleniumhq/selenium) and [Capybara](https://github.com/jnicklas/capybara)’s DSL
* Parses HTML/XML with [Nokogiri](http://nokogiri.org) and JSON with `::JSON` or [oj](https://github.com/ohler55/oj)
* Can extract metadata with [Pismo](https://github.com/peterc/pismo)
* Implements [ActiveJob](https://github.com/rails/rails/tree/master/activejob)’s API so you can use your favorite job queue
* Keeps track of URIs internally with an in-memory or [Redis]() frontier
* Leaves data extraction and storage up to you
* Comes with stellar documentation

__Shortcomings:__

* Does not care about `robots.txt`
* Does not cache responses
* Does not talk to proxies
* Does not run on JRuby

… and probably never will.

## Installation
Install with Bundler by adding the following line to your `Gemfile`:

```
gem "wayfarer"
```
Or install via RubyGems:

```
% gem install wayfarer
```

## What it looks like
Almost everything there is to know about Wayfarer is included in the following lines:

```ruby
require "wayfarer"

class WikipediaJob < Wayfarer::Job
  config do |c|
    # Use 4 Firefox processes
    c.http_adapter = :selenium
    c.connection_count = 8
  end

  # Routes map URIs to instance methods
  routes do
    draw :article, host: "en.wikipedia.org", path: "/wiki/:slug"
  end

  # Locals survive from page to page
  # Arrays and Hashes are replaced with thread-safe versions behind the scenes
  let(:list) { [] }
  let(:dict) { {} }

  # Callback that runs before any pages have been processed
  before_crawl :do_something

  # Callback that runs after all pages have been processed
  # You have access to locals in all callbacks
  after_crawl do
    list # => []
  end

  # ActiveJob callbacks will fire as expected
  after_perform { |job| }

  def article
    params["slug"] # URI path segment matching

    driver  # A Selenium WebDriver
    browser # A Capybara session that wraps the Selenium WebDriver

    page.uri
    page.body
    page.status_code
    page.headers

    page.doc   # A Nokogiri document
    page.pismo # A Pismo document

    page.links # All links
    page.links ".some-selector", ".another-selector" # Targeted links
    page.stylesheets
    page.javascripts
    page.images

    # Stage all linked URIs. Every URI that matches a route gets processed
    # No URI will ever get processed twice (by default)
    stage page.links

    # Disregard all staged URIs and stop processing
    halt
  end
end

# Run the job now:
WikipediaJob.crawl("https://en.wikipedia.org/wiki/Special:Random")

# ... or enqueue it:
WikipediaJob.perform_later("https://en.wikipedia.org/wiki/Special:Random")
```

You can run or enqueue jobs from the command line, too:

```
% wayfarer exec wikipedia_job https://en.wikipedia.org/wiki/Special:Random
```

```
% wayfarer enqueue wikipedia_job https://en.wikipedia.org/wiki/Special:Random --queue_adapter=sidekiq
```


See [examples/](examples/) and [docs/](docs/) for details.

## Testing
```
rake test           # Run all tests
rake test:isolated  # Run only environment-agnostic tests (no Selenium or Redis tests)
rake test:selenium  # Run only Selenium tests
rake test:redis     # Run only Redis tests
```

Selenium tests are run locally with [PhantomJS]().
In order to run Redis tests, you need a Redis server listening on port 6379.
