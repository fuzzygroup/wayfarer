---
layout: default
title: Halting
categories: [Basics]
---

# Halting
You can stop processing any time by calling `#halt` within actions.

<aside class="note">
<code>#halt</code> does not return immediately. Instead, it sets a halting flag internally, and once the action returns, halting is initiated.
</aside>

<aside class="note">
Every job instance runs inside its own thread. When a job signals that it wants to halt, all other threads will finish their current work, but will not process any more URIs. All instances have the chance to get their work done.
</aside>

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    halt
    puts "This will be printed!"

    return halt
    puts "This will not be printed!"
  end
end
{% endhighlight %}
