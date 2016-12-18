---
layout: default
title: Frontiers
categories: [Basics]
---

# Frontiers

Frontiers keep track of URIs:

* Current URIs that are being processed
* Staged URIs that might be processed in the next cycle
* Cached URIs that have been processed

## Available frontiers
Currently, there are 5 frontiers available:

1. `:memory_trie_frontier` (default): Uses a [trie](https://github.com/tyler/trie) and sets.
2. `:memory_frontier`: Uses sets from the standard lib.
3. `:memory_bloomfilter`: Uses a [Bloom filter](https://github.com/igrigorik/bloomfilter-rb).
4. `:redis_frontier`: Uses Redis sets.
5. `:redis_bloomfilter`: Uses a Redis-backed Bloom filter.

## Setting the frontier

Set the `:frontier` configuration key:

{% highlight ruby %}
class DummyJob < Wayfarer::Job
  config.frontier = :foobar
end
{% endhighlight %}


### Using a Redis frontier

### Setting bloomfilter parameters
