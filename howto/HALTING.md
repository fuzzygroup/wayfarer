# Halting
You can stop processing by calling `#halt` within an instance method of your Job class. Note that `#halt` does _not_ immediately return from the instance method. Instead, it sets a halting flag internally, and once your instance method returns, the processor will halt.

```ruby
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    halt
    puts "This will be printed!"
  end
end
```

If you want to return immediately, well … use Ruby’s `return` keyword:

```ruby
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    return halt
    puts "This will not be printed!"
  end
end
```

## Multithreading considerations
Every Job class is instantiated and run inside its own thread (see [Thread safety]()). This means that halting from within one thread will cause all other threads to be terminated as soon as the halting instance method returns.