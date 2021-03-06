---
layout: default
title: Versatile web crawling with Ruby
---

# Versatile web crawling with Ruby

Wayfarer is the swiss army knife for web crawling with Ruby.

If you …

* __Need to visit certain pages of a website__
* __Need to extract whatever data__
* Don't want to visit a page twice
* Do it multi-threaded
* Integrate with Rails seamlessly
* Want to automate a web-browser
* Need to execute arbitrary JavaScript
* Need to take screenshots
* Want to use a job queue and make work happen later
* Like OOP and testability
* Want in-memory and Redis-backed frontiers, tries and Bloom filters
* Value a small foot-print and thorough documentation

… then you've come to the right place!

## What it looks like

Say you want to …

* Start off with a random Wikipedia article
* Follow all links until you find a page with the word "Foobar"
* Want to extract all keywords from every page you encounter
* Want this to happen within 16 threads

This amounts to 17 lines with Wayfarer:

{% highlight ruby %}
class FindFoobar < Wayfarer::Job
  config.connection_count = 20

  let(:keywords) { [] }

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Foobar/
      puts "That's it! @ #{page.uri}"
      halt
    else
      keywords << page.pismo.keywords
      stage page.links
    end
  end
end

FindFoobar.perform_now("https://en.wikipedia.org/wiki/Special:Random")
{% endhighlight %}

Even better, Wayfarer integrates with [ActiveJob]() and supports your favorite job queue out of the box. Your job is ready to be enqueued:
{% highlight ruby %}
FindFoobar.perform_later("https://en.wikipedia.org/wiki/Special:Random")
{% endhighlight %}

### Where to go from here

* [The tutorial]() shows how to collect all open issues from a GitHub repository
* Read the [API documentation]()
