# Routing
Inside your Job classes, you declare a set of _routes_ that map URIs to _instance methods_. A route consists of at least one _rule_ that matches URIs you are interested in. URIs that match no route are ignored.

## Table of Contents

* Declaring routes
* Rule types
  * URI rules
  * Host rules
  * Path rules
  * Query rules
* Compound rules
* Nested rules  

## Declaring routes
The following four snippets all set up the same routes:

```ruby
class DummyJob < Wayfarer::Job
  route.draw :foo, uri: "https://example.com"
  route.draw :bar, uri: "https://w3c.org"

  def foo; end
  def bar; end
end
```

```ruby
class DummyJob < Wayfarer::Job
  routes do
    draw :foo, uri: "https://example.com"
    draw :bar, uri: "https://w3c.org"
  end

  def foo; end
  def bar; end
end
```

```ruby
class DummyJob < Wayfarer::Job
  routes do
    draw :foo do
      uri "https://example.com"
    end

    draw :bar do
      uri "https://w3c.org"
    end
  end

  def foo; end
  def bar; end
end
```

```ruby
class DummyJob < Wayfarer::Job
  draw uri: "https://example.com"
  def foo; end

  draw uri: "https://w3c.org"
  def bar; end
end
```

## Rule types
### URI rules
A URI rule takes a `String`, instantiates a `URI` from it and compares it with the URI in question by calling `#==`.

The following URI rule:

```ruby
draw uri: "https://example.com"
```
… matches only `https://example.com`.

### Host rules
A URI rule takes either a `String` or a `Regexp` and compares it with `uri.host` by calling `#===`.

#### Strings
The following host rule:

```ruby
draw host: "example.com"
```
… matches:

* `http://example.com`
* `https://example.com`
* `https://example.com/arbitrary/path`

… does not match:

* `http://sub.example.com`
* `https://w3c.org`

#### Regexps
The following host rule:

```ruby
draw host: /example.com/
```
… matches:

* `http://example.com`
* `https://example.com`
* `https://example.com/arbitrary/path`
* `http://sub.example.com`

… does not match:

* `https://w3c.org`

### Path rules
The behaviour of path rules depends on whether [mustermann](https://github.com/rkh/mustermann) has been required. When required, you can match path segments and you have access to a `params` hash inside your instance methods. Otherwise, paths are matched as Strings.

__NOTE:__ mustermann does not run on JRuby.

#### Without mustermann
The following path rule:

```ruby
draw path: "/foo/bar"
```
… matches:

* `http://example.com/foo/bar`
* `https://w3c.org/foo/bar`

… does not match:

* `http://example.com/foo/bar/`
* `http://example.com/foo`
* `http://w3c.org/foo/bar/baz`

#### With mustermann
The following host rule:

```ruby
draw path: ":foo/:bar"
```
… matches:

* `http://example.com/alpha/beta`

	Parameters: `{ "foo" => "alpha", "bar" => "beta" }`

* `https://w3c.org/x/y`, `params = { "foo" => "x", "bar" => "y" }`

	Parameters: `{ "foo" => "x", "bar" => "y" }`

… does not match:

* `http://example.com/foo/bar/`
* `http://example.com/foo`
* `http://w3c.org/foo/bar/qux`

### Query rules
A query rule takes a `Hash` whose key-value-pairs serve as matching constraints.

#### Strings
The following URI rule:

```ruby
draw query: { foo: "bar" }
```
… matches:

* `http://example.com?foo=bar`
* `http://example.com/baz?foo=bar&bar=qux`

… does not match:

* `http://example.com?foo=BAR`

#### Integers
The following URI rule:

```ruby
draw query: { foo: 42 }
```
… matches:

* `http://example.com?foo=42`
* `http://example.com/baz?foo=42&bar=qux`

… does not match:

* `http://example.com?foo=41`
* `http://w3c.org?foo=42.0`

#### Regexps
The following URI rule:

```ruby
draw query: { foo: /bar/ }
```
… matches:

* `http://example.com?foo=bar`
* `http://example.com/baz?foo=foobar`

… does not match:

* `http://example.com?foo=baz`

#### Ranges
The following URI rule:

```ruby
draw query: { foo: 24..42 }
```
… matches:

* `http://example.com?foo=32`
* `http://example.com/baz?foo=40`

… does not match:

* `http://example.com?foo=44`
* `http://w3c.org?foo=22`

#### Mixed query constraints
The following URI rule:

```ruby
draw query: { foo: "bar", bar: 42, qux: /baz/ }
```
… matches:

* `http://example.com?foo=bar&bar=42&qux=baz`

## Compound rules
The following compound rule:

```ruby
draw host: "example.com", path: "/foo/bar", query: { baz: "qux" }
```

… matches:

* `https://example.com/foo/bar?baz=qux`

## Nested rules
Rules themselves can have sub-rules. A rule matches if at least one of its sub-rules matches; and that sub-rule matches if at least one of its sub-rules-matches, and so on.

```ruby
draw do
  host "example.com" do
    path "/foo/bar" do
      query baz: "qux"
    end
  end

  host "https://w3c.org" do
    path "/baz"
    path "/qux"
  end

  host /example.org/, path: "/foo" do
    query bar: "qux"
  end
end
```

… matches:

* `http://example.com/foo/bar?baz=qux`

Rules can have multiple sub-rules.