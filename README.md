# Wayfarer
Versatile web crawling with Ruby

[__API documentation__]()

## Features
* Fires HTTP requests via [net-http-persistent](https://github.com/drbrain/net-http-persistent) or automates browsers with [Selenium](https://github.com/seleniumhq/selenium)
* Ensures non-circular, breadth-first and multithreaded traversal of page graphs
* Parses HTML/XML with [Nokogiri](http://nokogiri.org) and JSON with `::JSON` or [oj](https://github.com/ohler55/oj)
* Can extract metadata with [Pismo](https://github.com/peterc/pismo)
* Implements [ActiveJob](https://github.com/rails/rails/tree/master/activejob)’s job API so you can use your favorite job queue
* Ships with a small but useful CLI
* Is agnostic about data storage

__Shortcomings:__

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

## Examples
The following snippet traverses all open issues of an arbitrary GitHub repository and prints their IDs and titles:

```ruby
require "wayfarer"
require "mustermann"

class DummyJob < Wayfarer::Job
  routes do
    draw :overview,      host: "github.com", path: "/:user/:repo"
    draw :issue_listing, host: "github.com", path: "/:user/:repo/issues"
    draw :issue,         host: "github.com", path: "/:user/:repo/issues/:issue_id"
  end

  def overview
    visit issue_listing_uri
  end

  def issue_listing
    visit issue_uris
    visit next_issue_listing_uri
  end

  def issue
    puts "I'm issue No. #{params['issue_id']}"
  end

  private

  def issue_listing_uri
    page.links ".sunken-menu-group:first-child li:nth-child(2) a"
  end

  def issue_uris
    page.links ".issue-title-link"
  end

  def next_issue_listing_uri
    page.links ".next_page"
  end
end

DummyJob.crawl("https://github.com/rails/rails")
```

More contrived examples:

* [Finding Hitler on Wikipedia](howto/GETTING_STARTED.md)
* [Executing JavaScript and taking screenshots with Selenium](howto/GETTING_STARTED.md)

## Howto
* [Getting started](howto/GETTING_STARTED.md)
* [Page objects](howto/PAGE_OBJECTS.md)
* [Routing](howto/ROUTING.md)
* [Halting](howto/HALTING.md)
* [Configuration](howto/CONFIGURATION.md)
* [Using Selenium](howto/SELENIUM.md)
* [Error handling](howto/ERROR_HANDLING.md)
* [Thread safety](howto/THREAD_SAFETY.md)
* [Adapter timeouts](howto/ADAPTER_TIMEOUTS.md)
* [Optional MRI-only features](howto/MRI_FEATURES.md)

## Testing
Tests are run on:

* MRI 2.1.2p95
* JRuby 1.7.9

```
rake test           # Run all tests
rake test:isolated  # Run only environment-agnostic tests
rake test:jruby     # Run only JRuby tests
rake test:mri       # Run only MRI tests
rake test:selenium  # Run only Selenium tests
```

Selenium tests are run locally with [PhantomJS]().
