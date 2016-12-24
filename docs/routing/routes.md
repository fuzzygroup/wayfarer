---
layout: default
title: Routes
categories: [Routing]
---

# Routes

Routes are filters for URIs that you're interested in. They map certain URIs to instance methods (actions). Every route has a rule tree. A rule imposes conditions on URIs that they must fulfill in order to get processed. Rules can have sub-rules.

Routes match in declaration order.

Roues can be fordidden. Forbidden routes are never processed.

## Example

Suppose you want to route the following URI:
  `https://example.com/resource?foo=bar&page=42`

## Declaration styles

The following four snippets all set up the same routes:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  route.draw :foo, uri: "https://example.com"
  route.draw :bar, uri: "https://w3c.org"

  def foo; end
  def bar; end
end
{% endhighlight %}

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  routes do
    draw :foo, uri: "https://example.com"
    draw :bar, uri: "https://w3c.org"
  end

  def foo; end
  def bar; end
end
{% endhighlight %}

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  routes do
    draw :foo do
      uri "https://example.com"
    end

    draw :bar do
      uri "https://w3c.org"
    end
  end

  def foo; end
  def bar; end
end
{% endhighlight %}

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def foo; end

  draw uri: "https://w3c.org"
  def bar; end
end
{% endhighlight %}

# Declaring routes

In your Job classes, you declare a set of __routes__ that map URIs to __instance methods__. A route consists of __rules__ that match URIs you are interested in. Rules can be __forbidden__ as well. URIs that match no route or match forbidden rules are ignored. Rules themselves can have sub-rules. A rule with sub-rules matches if the rule itself matches and at least one of its sub-rules matches. This recursively applies to all rules and their sub-rules.
