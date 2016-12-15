---
layout: default
title: Halting
categories: [Basics]
---

# Halting
You can stop processing any time by calling `#halt` within an instance method of your job class. Note that `#halt` does _not_ immediately return from the instance method. Instead, it sets a halting flag internally, and once your instance method returns, the `Processor` will halt.

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
Every job instance runs inside its own thread. When a job signals the `Processor` that it should halt, all other threads will finish their current URI, and process no further URIs. Thus, halting is not "immediate", rather the job terminates as soon as possible and your other instances have the chance to get their work done.
