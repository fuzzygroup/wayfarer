# Error handling
By default, all exceptions raised within Job classes are swallowed and only their stacktraces are printed. You can change this behaviour with two Boolean configuration keys (see [Configuration]()):

1. `print_stacktraces`: Whether to print stacktraces.
2. `reraise_exceptions`: Whether to crash when encountering unhandled exceptions.

Here’s an example:

```ruby
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    fail "Only a stacktrace will be printed, execution continues"
  end
end
```

The following reraises all exceptions, stops execution and returns with a non-zero exit code:

```ruby
class DummyJob < Wayfarer::Job
  config.reraise_exceptions = true

  draw uri: "https://example.com"
  def example
    fail "Only a stacktrace will be printed, execution continues"
  end
end
```

… and if you don’t want to be notified about exceptions at all:

```ruby
class DummyJob < Wayfarer::Job
  config.print_stacktraces = false

  draw uri: "https://example.com"
  def example
    fail "Only a stacktrace will be printed, execution continues"
  end
end
```