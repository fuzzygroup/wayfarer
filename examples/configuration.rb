require_relative "../lib/wayfarer"

Wayfarer.config do |c|
  c.http_adapter       = :selenium
  c.selenium_argv      = [:firefox]
  c.connection_count   = 2
  c.reraise_exceptions = true
  c.print_stacktraces  = true
end

class DummyJob < Wayfarer::Job
  config do |config|
    config.http_adapter       = :selenium
    config.selenium_argv      = [:firefox]
    config.connection_count   = 2
    config.reraise_exceptions = true
    config.print_stacktraces  = true
  end
end
