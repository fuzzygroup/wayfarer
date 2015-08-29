# Getting started
wayfarer has you write a single Ruby class (_Jobs_) that defines a set of _routes_ that map URIs to _instance methods_. A route consists of a number of _rules_ (e.g. host rules, path rules, …) that matches URIs you are interested in.

For demonstration purposes, we’ll write a Job class that collects the titles of all open issues from an arbitrary GitHub repository.

You can view the end-result at [examples/github.rb]().

First things first, subclass `Wayfarer::Job`:

```ruby
require "wayfarer"

class DummyJob < Wayfarer::Job
end
```

Suppose we’re interested in Rails’ repository, which is located at `https://github.com/rails/rails`. We need two things to start off: A route that matches that URI, and an instance method which handles that page:

```ruby
class DummyJob < Wayfarer::Job
  route.draw :overview, uri: "https://github.com/rails/rails"

  def overview
    puts "This looks like Rails to me!" 
  end
end
```

This will do. Instead of instantiating Job classes on your own, call `::crawl` and pass an arbitrary number of URIs:

```ruby
class DummyJob < Wayfarer::Job
  route.draw :overview, uri: "https://github.com/rails/rails"

  def overview
    puts "This looks like Rails to me!" 
  end
end

DummyJob.crawl("https://github.com/rails/rails", "https://example.com")
```

Note that we’re passing a URI we have no matching route for, `https://example.com`. Run this file and you get output similiar to what follows:

```
D, [...] DEBUG -- : [#<DummyJob:...>] Dispatched to #overview: https://github.com/rails/rails
D, [...] DEBUG -- : [#<Wayfarer::Processor:...>] No route for URI: https://example.com
This looks like Rails to me!
```

URIs that match no route are ignored, while matching URIs are fetched, and the corresponding instance method gets invoked.

Let’s print the page title. Inside our instance method, call `#doc`  to get ahold of a [`Nokogiri::HTML::Document`](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/HTML/Document):

```ruby
class DummyJob < Wayfarer::Job
  route.draw :overview, uri: "https://github.com/rails/rails"

  def overview
    puts doc.title
  end
end

DummyJob.crawl("https://github.com/rails/rails")
```

Output:

```ruby
D, [...] DEBUG -- : [#<DummyJob:...>] Dispatched to #overview: https://github.com/rails/rails
rails/rails · GitHub
```

Looks reasonable. wayfarer does not attempt to do magic on top of Nokogiri. When it comes to extracting specific data from pages, you’re on your own.

Rails’ issues are located at `https://github.com/rails/rails/issues`. We need a new route and a new instance method. By calling `#visit` and passing in an arbitrary number of URIs, we can _stage_ URIs for processing. Note that just because a URI gets staged does not mean it will be fetched—a matching route is required for every URI.

```ruby
class DummyJob < Wayfarer::Job
  routes do
    draw :overview, uri: "https://github.com/rails/rails"
    draw :issues,   uri: "https://github.com/rails/rails/issues"
  end

  def overview
    visit "https://github.com/rails/rails/issues"
  end

  def issues
    puts "Rails got some issues."
  end
end

DummyJob.crawl("https://github.com/rails/rails")
```

Output:

```ruby
D, [...] DEBUG -- : [#<DummyJob:...>] Dispatched to #overview: https://github.com/rails/rails
D, [...] DEBUG -- : [#<DummyJob:...>] Dispatched to #issues: https://github.com/rails/rails/issues
Rails got some issues.
```

What we have so far works fine for the Rails repository, but not for any others, because the URIs are hardcoded. Instead of using a _URI rule_, we switch over to a _host_ and _path_ rule.



```ruby
require "wayfarer"
require "mustermann"

class DummyJob < Wayfarer::Job
  routes do
    draw :overview, host: "github.com", path: ":user/:repo"
    draw :issues,   host: "github.com", path: ":user/:repo/issues"
  end

  def overview
    visit "https://github.com/rails/rails/issues"
  end

  def issues
    puts "Rails got some issues."
  end
end

DummyJob.crawl("https://github.com/rails/rails")
```

And instead of `#visit`ing the hardcoded issues URI, we introduce a helper method that returns the URI:

```ruby
require "wayfarer"
require "mustermann"

class DummyJob < Wayfarer::Job
  routes do
    draw :overview, host: "github.com", path: ":user/:repo"
    draw :issues,   host: "github.com", path: ":user/:repo/issues"
  end

  def overview
    visit "https://github.com/rails/rails/issues"
  end

  def issues
    puts "Rails got some issues."
  end

  private

  def issues_uri
  end
end

DummyJob.crawl("https://github.com/rails/rails")
```

URIs never get dispatched to private instance methods.