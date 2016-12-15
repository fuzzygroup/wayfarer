---
layout: default
title: Declaring routes
categories: [Routing]
---

# Declaring routes

In your Job classes, you declare a set of __routes__ that map URIs to __instance methods__. A route consists of __rules__ that match URIs you are interested in. Rules can be __forbidden__ as well. URIs that match no route or match forbidden rules are ignored. Rules themselves can have sub-rules. A rule with sub-rules matches if the rule itself matches and at least one of its sub-rules matches. This recursively applies to all rules and their sub-rules.

The following four snippets all set up the same routes:

```ruby
class DummyJob < Wayfarer::Job
  route.draw :foo, uri: "https://example.com"
  route.draw :bar, uri: "https://w3c.org"

  def foo; end
  def bar; end
end
```

```ruby
class DummyJob < Wayfarer::Job
  routes do
    draw :foo, uri: "https://example.com"
    draw :bar, uri: "https://w3c.org"
  end

  def foo; end
  def bar; end
end
```

```ruby
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
```
