# Page objects
Pages retrieved by an HTTP adapter are represented by a `Page` object and made accessible by `#page` within instance methods:

```ruby
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def example
    page # => #<Wayfarer::Page:...>
  end
end

DummyJob.crawl("https://example.com")
```

## `#uri`
`#uri` returns the URI.

__NOTE:__ When 3xx redirects have been followed, 

## `#status_code`
`#status_code` returns the HTTP status code the webserver responded with.

## `#body`
asdfsadf

## `#headers`

## `#doc`
Depending on the `Content-Type` field the webserver responded with, `#doc` returns a parsed representation of the document:

* HTML:

## `#pismo`
Depending on the `Content-Type` field the webserver responded with, `#doc` returns a parsed representation of the document:

* HTML: