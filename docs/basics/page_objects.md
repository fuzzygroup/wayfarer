---
layout: default
title: Page objects
categories: [Basics]
---

# `Page` objects

Retrieved pages are represented by a `Page` object and made accessible by `#page` within actions.

A `Page` brings to the table all you'd wish for when doing web scraping:

* [Nokogiri](http://www.nokogiri.org) parses HTML/XML
* [Oj](https://github.com/ohler55/oj) parses JSON
* [Pismo](https://github.com/peterc/pismo) lets you access metadata, e.g. keywords, author, a summary, …

Let's see it in action:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    page # => #<Wayfarer::Page:...>

    page.uri # => #<URI::...>
    page.status_code # => Fixnum
    page.body # => String
    page.headers # => Hash

    page.doc # => #<Nokogiri::HTML::Document:...>

    page.links # => [URI]
    page.stylesheets # => [URI]
    page.javascripts # => [URI]
    page.images # => [URI]

    # All previous four methods accept arbitrary many CSS selectors
    page.links ".my-target", ".my-other-target"

    # The following methods get forwarded to a Pismo::Document
    # See https://github.com/peterc/pismo
    page.title
    page.titles
    page.author
    page.lede
    page.keywords
    page.sentences(qty)
    page.body
    page.html_body
    page.feed
    page.feeds
    page.favicon
    page.description
    page.datetime
  end
end
{% endhighlight %}
