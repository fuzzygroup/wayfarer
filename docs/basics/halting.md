---
layout: default
title: Halting
categories: [Basics]
---

# Halting
You can stop processing any time by calling `#halt` within actions. Note that `#halt` does __not__ immediately return from the instance method. Instead, it sets a halting flag internally, and once your instance method returns, the processor reacts to your halt intent.

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    halt
    puts "This will be printed!"
  end
end
{% endhighlight %}

If you want to return immediately, well … use Ruby’s `return` keyword:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    return halt
    puts "This will not be printed!"
  end
end
{% endhighlight %}

## Multithreading considerations
Every job instance runs inside its own thread. When a job signals the `Processor` that it should halt, all other threads will finish their current URI, and process no further URIs. Halting is not "immediate", rather your other instances have the chance to get their work done.
