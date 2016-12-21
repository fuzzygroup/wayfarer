---
layout: default
title: Configuration
categories: [Basics]
---

# Configuration

All job classes base their configuration off the global one.

{% highlight ruby %}
# Setting a key globally applies to all jobs ...
Wayfarer.config.key = :value

class DummyJob < Wayfarer::Job
  # ... unless a job overrides it
  config.key = :other_value
end

class DummyJob < Wayfarer::Job
  # Have it yielded
  config { |c| c.key = :other_value }
end
{% endhighlight %}

## Recognized keys and values

### `print_stacktraces`
  * Default: `true`
  * Recognized values: Booleans

Whether to print stacktraces when encounterting unhandled exceptions in job actions. See [Error handling](error_handling.html).

--

### `reraise_exceptions`

* Default: `false`
* Recognized values: Booleans

Whether to crash when encountering unhandled exceptions in job actions. See [Error handling](error_handling.html).

--

### `allow_circulation`

* Default: `false`
* Recognized values: Booleans

Whether URIs may be visited twice.

<aside class="note">
Allowing circulation might cause your jobs to not terminate.
</aside>

--

### `frontier`
* Default: `:memory_trie`
* Recognized values: `:memory_trie`, `:memory`, `:memory_bloom`, `:redis`, `:redis_bloom`

Which frontier to use. See [(Redis) frontiers](frontiers.html).

<aside class="note">
Bloom filters may yield false positives. See the <a href="https://en.wikipedia.org/wiki/Bloom_filter">Wikipedia article</a>.
</aside>

--

### `connection_count`

* Default: `4`
* Recognized values: Integers

How many threads and HTTP adapters to use (1:1 correspondence).

--

### `http_adapter`

* Default: `:net_http`
* Recognized values: `:net_http`, `:selenium`

Which HTTP adapter to use. See [Selenium & Capybara](selenium_capybara.html).

--

### `connection_timeout`

* Default: `Float::INFINITY`
* Recognized values: Floats

Time in seconds that a job instance may hold an HTTP adapter. Instances that exceed this time limit raise an exception.

--

### `max_http_redirects`

* Default: `3`
* Recognized values: Integers

How many 3xx redirects to follow.

<aside class="note">
Has no effect when using the <code>:selenium</code> HTTP adapter.
</aside>

--

### `selenium_argv`

* Default: `[:firefox]`
* Recognized values: See [Selenium & Capybara](selenium_capybara.html)

Argument vector passed to [`Selenium::WebDriver::Driver::for`](http://www.rubydoc.info/gems/selenium-webdriver/Selenium/WebDriver/Driver#for-class_method).

--

### `redis_opts`

* Default: `{ host: "localhost", port: 6379 }`
* Recognized values: [See documentation](http://www.rubydoc.info/github/redis/redis-rb/Redis%3Ainitialize)

Options passed to [`Redis#initialize`](http://www.rubydoc.info/github/redis/redis-rb/Redis%3Ainitialize).

--

### `bloomfilter_opts`

* Default:
```
{
  size: 100,
  hashes: 2,
  seed: 1,
  bucket: 3,
  raise: false
}
```
* Recognized values:
  * `size`: Integers; number of buckets in a bloom filter
  * `hashes`: Integers; number of hash functions
  * `seed`: Integers; seed of hash functions
  * `bucket`: Integers; number of bits in a bloom filter bucket
  * `raise`: Booleans; whether to raise on bucket overflow

Options for [bloomfilter-rb](https://github.com/igrigorik/bloomfilter-rb).

--

### `window_size`

* Default: `[1024, 768]`
* Recognized values: `[Integer, Integer]`

Dimensions of browser windows.

<aside class="note">
Only has an effect when using the <code>:selenium</code> HTTP adapter.
</aside>

--

### `mustermann_type`

* Default: `:sinatra`
* Recognized values: [See documentation](https://github.com/sinatra/mustermann)

Which [Mustermann](https://github.com/sinatra/mustermann) pattern type to use.
