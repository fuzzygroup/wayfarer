---
layout: default
title: Frontiers
categories: [Basics]
---

# Frontiers

Frontiers keep track of three sets of URIs:

* Current URIs that are being processed
* Staged URIs that might be processed in the next cycle
* Cached URIs that have been processed

All frontiers expose the same behaviour. 

<pre class="illustration">
┌──────────────────────────────────────────────────────────┐
│                          STAGED                          │
│          {https://alpha.com, https://beta.com}           │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│                         CURRENT                          │
│                   {https://gamma.com}                    │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│                          CACHED                          │
│                    {https://beta.com}                    │
└──────────────────────────────────────────────────────────┘
                             │
                           Cycle
                             │
                             ▼
┌──────────────────────────────────────────────────────────┐
│                         STAGED'                          │
│                          {...}                           │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│                CURRENT' = STAGED \ CACHED                │
│                   {https://alpha.com}                    │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│                CACHED' = CACHED ∪ CURRENT                │
│          {https://beta.com, https://gamma.com}           │
└──────────────────────────────────────────────────────────┘
</pre>


## Available frontiers
Currently, there are 5 frontiers available:

1. `:memory_trie` (default): Uses a [trie](https://github.com/tyler/trie) and sets.
2. `:memory`: Uses sets from the standard lib.
3. `:memory_bloom`: Uses a [Bloom filter](https://github.com/igrigorik/bloomfilter-rb).
4. `:redis`: Uses Redis sets.
5. `:redis_bloom`: Uses a Redis-backed Bloom filter.

## Setting the frontier

Set the `:frontier` configuration key:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config.frontier = :foobar
end
{% endhighlight %}


### Using a Redis frontier

### Setting bloomfilter parameters
