---
layout: default
title: Error handling
categories: [Basics]
---

# Error handling
By default, all exceptions raised within actions are swallowed and only their stacktraces printed to stderr. You can change this behaviour with two configuration keys (see [Configuration]()):

1. `print_stacktraces`: Whether to print stacktraces (default: `true`)
2. `reraise_exceptions`: Whether to crash when encountering unhandled exceptions (default: `false`)

Here’s an example to illustrate the default behaviour:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    # Makes this instance fail, but processing goes on
    # Prints the stacktrace to stderr
    fail "It's okay, life goes on"
  end
end
{% endhighlight %}

The following reraises all exceptions, stops processing and returns with a non-zero exit code:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config.reraise_exceptions = true

  draw uri: "https://example.com"
  def example
    fail "This will make the whole thing crash!"
  end
end
{% endhighlight %}

And if you don’t want to be bothered with exceptions at all:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config.print_stacktraces = false

  draw uri: "https://example.com"
  def example
    fail "No one will know about this ..."
  end
end
{% endhighlight %}
