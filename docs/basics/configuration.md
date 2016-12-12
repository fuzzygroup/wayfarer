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
  # ... unless a job overrides it.
  config.key = :other_value
end

class DummyJob < Wayfarer::Job
  # You can also pass in a block and get yielded the config.
  config do |c|
    c.key = :value
  end
end
{% endhighlight %}

## Recognized keys and values

### `print_stacktraces`
* Default: `true`
* Recognized values: Booleans

Whether to print stacktraces when encounterting unhandled exceptions. See [Error handling](ERROR_HANDLING.md).

--

### `reraise_exceptions`
* Default: `false`
* Recognized values: Booleans

Whether to crash when encountering unhandled exceptions. See [Error handling](ERROR_HANDLING.md).

--

### `allow_circulation`
* Default: `false`
* Recognized values: Booleans

Whether URIs may be visited twice.

__NOTE:__ Allowing circulation might cause your jobs to not terminate.

--

### `frontier`
* Default: `:memory`
* Recognized values: `:memory`, `:redis`

Which frontier to use.

--

### `connection_count`
* Default: `4`
* Recognized values: Integers

How many threads and HTTP adapters to use (1:1 correspondence).

--

### `http_adapter`
* Default: `:net_http`
* Recognized values: `:net_http`, `:selenium`

Which HTTP adapter to use. See [Using Selenium](SELENIUM.md).

--

### `connection_timeout`
* Default: `5.0`
* Recognized values: Floats

--

### `max_http_redirects`
* Default: `3`
* Recognized values: Integers

How many 3xx redirects to follow.

__NOTE:__ Has no effect when using Selenium.

--

### `selenium_argv`
* Default: `[:firefox]`
* Recognized values: [See documentation]()

Argument vector for instantiating Selenium drivers. See [Using Selenium](SELENIUM.md).

--

### `redis_argv`
* Default: `[host: "localhost", port: 6379]`
* Recognized values: [See documentation]()

Argument vector for instantiating Redis connections. See [Using the Redis frontier](SELENIUM.md).

--

### `window_size`
* Default: `[1024, 768]`
* Recognized values: `[Integer, Integer]`

Dimensions of browser windows.

--

### `mustermann_type`
* Default: `:sinatra`
* Recognized values: [See documentation]()

Which Mustermann pattern type to use when matching URI paths. See [Routing](ROUTING.md).
