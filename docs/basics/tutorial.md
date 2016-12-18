---
layout: default
title: Tutorial
categories: [Basics]
---

# Tutorial
This tutorial walks you through 96.333% of what's to know about Wayfarer. Along the way, we'll write a reusable crawler that collects the titles of all open issues from an arbitrary GitHub repository.

You can view the end-result at [examples/github.rb]().

First things first, we get ourselves a subclass of `Wayfarer::Job`. If you've ever worked with a typical MVC web framework, think of a job as a self-contained controller with routes.

{% highlight ruby %}
# I'll omit this line hereafter
require "wayfarer"

class CollectGithubIssues < Wayfarer::Job
end
{% endhighlight %}

Suppose we’re interested in the Rails repository, which is located at `https://github.com/rails/rails`. We need two things to start off: A route that matches that URI, and an instance method which handles that page:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  route.draw :repository, uri: "https://github.com/rails/rails"

  def repository
    puts "This looks like Rails to me!"
  end
end
{% endhighlight %}

This will do. We set up a single route which maps the repository URI (and only this URI) to `CollectGithubIssues#overview`. Whenever we feed the job that URI, that very method takes the stage.

Let's do this. Instead of instantiating jobs on your own, call `::perform_now` and pass an arbitrary number of URIs:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  route.draw :repository, uri: "https://github.com/rails/rails"

  def repository
    puts "This looks like Rails to me!"
  end
end

# So we get more detailed output
# I'll omit this line hereafter
Wayfarer.log.level = :debug

# I'll omit this line hereafter. Make sure you don't!
CollectGithubIssues.perform_now("https://github.com/rails/rails", "https://example.com")
{% endhighlight %}

Note that we’re passing a URI we have no matching route for, `https://example.com`. Run this file (as you would with every other Ruby file) and you'll end up with output similiar to this:

```
[ActiveJob] [CollectGithubIssues] [...] Performing CollectGithubIssues from Inline(default) with arguments: "https://github.com/rails/rails", "https://example.com"
D, [...] DEBUG -- : [#<Wayfarer::Processor:...>] About to cycle
D, [...] DEBUG -- : [#<CollectGithubIssues:...>] Dispatched to #overview: https://github.com/rails/rails
D, [...] DEBUG -- : [#<Wayfarer::Processor:...>] No matching route for https://example.com
This looks like Rails to me!
D, [...] DEBUG -- : [#<Wayfarer::Processor:...>] Staging 0 URIs
D, [...] DEBUG -- : [#<Wayfarer::Processor:...>] About to cycle
D, [...] DEBUG -- : [#<Wayfarer::Processor:...>] All done
D, [...] DEBUG -- : [#<Wayfarer::Processor:...>] Freeing adapter pool
[ActiveJob] [CollectGithubIssues] [...] Performed CollectGithubIssues from Inline(default) in 816.34ms
```

The debugging output nicely demonstrates how Wayfarer's internals work. Wayfarer is easy to grasp. I'll walk you through some lines:

1. `[#<Wayfarer::Processor:...>] About to cycle`
The URIs you pass to `#perform_now` get staged, i.e. added to a list of URIs that you potentially want to visit. Because there are no current URIs, only staged ones, the `Processor` cycles: All staged URIs that have not been processed yet become current URIs. All others are ignored.
2. `[#<CollectGithubIssues:...>] Dispatched to #overview: https://github.com/rails/rails`
Note that the logging output comes from an instance of our job class. When the `Processor` is done with cycling, each current URI gets processed by an instance of our class. If a URI matches a route, it is fetched, and the class calls the corresponding instance method. In this case, that's `#overview`. It  printed _This looks like Rails to me!_ to stdout.

3. `[#<Wayfarer::Processor:...>] Staging 0 URIs`
The instance of our job that matched and processed `https://github.com/rails/rails` reported back to the `Processor` that it does not want to stage any URIs for processing. It is up to your instance methods to tell the `Processor` where to go next.

4. `[#<Wayfarer::Processor:...>] All done`
The `Processor` cycled, and because we haven't staged any URIs, there are no URIs to set as current. The job then terminates.

Let’s replace the hard-coded string with the page `<title>`. Inside our instance method, we call `#doc` to get ahold of a [`Nokogiri::HTML::Document`](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/HTML/Document). [Nokogiri]() is a HTML/XML library, and a parsed document allows us to access the title easily:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  route.draw :repository, uri: "https://github.com/rails/rails"

  def repository
    # Outputs the <title> attribute value
    puts doc.title
  end
end
{% endhighlight %}

Wayfarer does not attempt to do black magic on top of Nokogiri. When it comes to extracting specific data from pages, you’re mostly on your own. There are helpers (see [Finders]()) for finding links, CSS/JavaScript files and images. But figuring out what HTML elements you're interested in is still up to you. Wayfarer will happily parse JSON, too. You'll get a `Hash` returned by `#doc` instead of a parsed Nokogiri document.

Rails’ issues are located at `https://github.com/rails/rails/issues`. We need a new route and a new instance method to handle this issue index. By calling `#stage` and passing in an arbitrary number of URIs, we can stage URIs for processing. Note that just because a URI gets staged does not mean it will be fetched—a matching route is required for every URI. Also, Wayfarer will by default ensure that no URI gets processed twice. This can be turned off, though (see [Configuration]()).

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  routes do
    draw :repository,  uri: "https://github.com/rails/rails"
    draw :issue_index, uri: "https://github.com/rails/rails/issues"
  end

  def repository
    # This is where we want to head at
    stage "https://github.com/rails/rails/issues"
  end

  def issue_index
    # We've arrived at the issue index!
    puts "Rails got some issues."
  end
end
{% endhighlight %}

What we have so far works fine for the Rails repository, but not for others, because the URIs are hardcoded. That's a real pity, because there are more than 10 million repositories on GitHub. Surely we can do better! Instead of using a URI rule, we switch to a host and path rule.

A host rule narrows down the host portion of a URI, and a path rule the path. Instead of hard-coding the path, we can use pattern matching and have interesting parts of the path extracted for us:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  routes do
    # Both routes match only if
    # (1) The host is github.com and
    # (2) The path is as specified
    draw :repository,  host: "github.com", path: "/:user/:repo"
    draw :issue_index, host: "github.com", path: "/:user/:repo/issues"
  end

  def repository
    stage "https://github.com/rails/rails/issues"
  end

  def issue_index
    # You have access to the extracted path parameters: params # => { repo: ...}
    # Prints 'rails belongs to rails'.
    puts "#{params['repo']} belongs to #{params['user']}"
  end
end
{% endhighlight %}

Note that the issue index's URI is still hard-coded. Usually, when doing web scraping, there are two possibilities you identify URIs on a page that you want to follow:

1. You can construct the next URI from the current URI.
2. The URI you're interested in is contained in the response, e.g. in a `<a>` tag's `href` property.

For the first case, say we're on `https://github.com/:user/:repo` and want to go to `https://github.com/:user/:repo/issues`. All that separates both URIs is the last path segment, and you can simply append it at runtime:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  # ...

  def repository
    stage page.uri << "/issues"
  end

  # ...
end
{% endhighlight %}

`#page` returns a [`Page` object](), the general representation of a retrieved page. It gives you access to the origin URI, the response headers, the status code and the raw response body and more.

The second case is where Wayfarer's routing really shines. You know that the path structure is `/:user/:repo/issues` and that there's a link somewhere on the repository's frontpage that links to there. In order to iterate quickly, you can stage all links of the current page, and have your routes ensure that only the interesting ones get processed.

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  # ...

  def repository
    # But only route-matching one's get processed
    stage page.links
  end

  # ...
end
{% endhighlight %}

`Page#links` returns all links of the current site. But staging all links brings overhead with it, and you'll want to narrow down the links you stage, especially when crawling large page structures. `Page#links` lets you narrow down the links you want to stage by passing in an arbitrary number of CSS selectors. For clarity, let's give the interesting link its own private helper method:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  routes do
    draw :repository,  host: "github.com", path: "/:user/:repo"
    draw :issue_index, host: "github.com", path: "/:user/:repo/issues"
  end

  def repository
    stage issue_index_uri
  end

  def issue_index
    puts "#{params['repo']} belongs to #{params['user']}"
  end

  private

  def issue_index_uri
    page.links ".reponav-item"
  end
end
{% endhighlight %}

URIs never get dispatched to private instance methods.

We're prepared to go after the individual issues now. We add the `#issue` action, and route to it with a host and path rule. Links to an issue have the class `.issue-title-link`, so we can apply the same technique as above:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  routes do
    draw :repository,  host: "github.com", path: "/:user/:repo"
    draw :issue_index, host: "github.com", path: "/:user/:repo/issues"
    draw :issue,       host: "github.com", path: "/:user/:repo/issues/:id"
  end

  def repository
    stage issue_index_uri
  end

  def issue_index
    stage issue_uris
  end

  def issue
    puts "Now that's an issue!"
  end

  private

  def issue_index_uri
    page.links ".reponav-item"
  end

  def issue_uris
    page.links ".Box-row-link"
  end
end

CollectGithubIssues.perform_now("https://github.com/rails/rails")
{% endhighlight %}

Nothing new here. What’s left is paginating through all issue indexs:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  routes do
    draw :repository,  host: "github.com", path: "/:user/:repo"
    draw :issue_index, host: "github.com", path: "/:user/:repo/issues"
    draw :issue,       host: "github.com", path: "/:user/:repo/issues/:id"
  end

  def repository
    stage issue_index_uri
  end

  def issue_index
    stage issue_uris, next_issue_index_uri
  end

  def issue
    puts "I'm issue No. #{params['id']}"
  end

  private

  def issue_index_uri
    page.links ".reponav-item"
  end

  def issue_uris
    page.links ".Box-row-link"
  end

  def next_issue_index_uri
    page.links ".next_page"
  end
end

CollectGithubIssues.perform_now("https://github.com/rails/rails")
{% endhighlight %}

By default, all this work happens within a single thread. Let's bump up the number of threads to 16:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  config.connection_count = 16

  # ...
end
{% endhighlight %}

While we're at it, why not collect all these issues, instead of writing them to stdout immediately? We'll use a Hash and store the page titles keyed by the issue's ID:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  routes do
    draw :repository,  host: "github.com", path: "/:user/:repo"
    draw :issue_index, host: "github.com", path: "/:user/:repo/issues"
    draw :issue,       host: "github.com", path: "/:user/:repo/issues/:id"
  end

  # Locals are accessible from your instance methods
  let(:issues) { {} }

  def repository
    stage issue_index_uri
  end

  def issue_index
    stage issue_uris
    stage next_issue_index_uri
  end

  def issue
    issues[params["id"]] = doc.title
  end

  private

  def issue_index_uri
    page.links ".reponav-item"
  end

  def issue_uris
    page.links ".Box-row-link"
  end

  def next_issue_index_uri
    page.links ".next_page"
  end
end

CollectGithubIssues.perform_now("https://github.com/rails/rails")
{% endhighlight %}

You might recognize `::let` from RSpec but here it has completely different semantics: No lazy evaluation; the block you pass in is evaluated instantaneously.

There's a twist to `::let`, though. We just bumped the number of threads to 16. Ruby's Hashes are not thread-safe. That's why `::let` replaces both Hashes and Arrays with [thread-safe replacements](https://github.com/ruby-concurrency/thread_safe) behind the scenes for you.

Now we're collecting issue titles, but we haven't had the chance to do anything with them: After no URIs are left to process, the job terminates. We can use the `::after_crawl` callback to do something useful with locals:

{% highlight ruby %}
class CollectGithubIssues < Wayfarer::Job
  routes do
    draw :repository,      host: "github.com", path: "/:user/:repo"
    draw :issue_index, host: "github.com", path: "/:user/:repo/issues"
    draw :issue,         host: "github.com", path: "/:user/:repo/issues/:id"
  end

  let(:issues) { {} }

  after_crawl do
    issues.each do |(id, title)|
      puts "#{id} -- #{title}"
    end
  end

  def repository
    stage issue_index_uri
  end

  def issue_index
    stage issue_uris
    stage next_issue_index_uri
  end

  def issue
    issues[params["id"]] = doc.title
  end

  private

  def issue_index_uri
    page.links ".reponav-item"
  end

  def issue_uris
    page.links ".Box-row-link"
  end

  def next_issue_index_uri
    page.links ".next_page"
  end
end

CollectGithubIssues.perform_now("https://github.com/rails/rails")
{% endhighlight %}

There's also `::before_crawl`. Both callbacks fire on the main thread.
