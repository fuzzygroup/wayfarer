# Wayfarer
A versatile web crawling/scraping DSL for MRI and JRuby

## Features
* Fires HTTP requests via [net-http-persistent](https://github.com/drbrain/net-http-persistent) or automates JavaScript-enabled browsers with [Selenium](https://github.com/seleniumhq/selenium)
* Ensures non-circular, breadth-first and multithreaded traversal of page graphs
* Parses HTML/XML with [Nokogiri](http://nokogiri.org) and JSON with `::JSON` or [oj](https://github.com/ohler55/oj)
* Extracts metadata with [Pismo](https://github.com/peterc/pismo) if needed
* Is agnostic about data storage

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

## Howto
* [Getting started](howto/GETTING_STARTED.md)
* [Routing](howto/ROUTING.md)
* [Halting](howto/HALTING.md)
* [Internals](howto/INTERNALS.md)
* [Thread safety](howto/THREAD_SAFETY.md)
* [Configuration](howto/CONFIGURATION.md)
* [Using Selenium](howto/SELENIUM.md)
* [Extracting metadata with Pismo]()

## Running the tests
See `% rake -T`.
