# Routing
Inside your Job classes, you declare a set of _routes_ that map URIs to _instance methods_. A route consists of _rules_ that match URIs you are interested in. Rules can be _forbidden_ as well. URIs that match no route or match forbidden rules are ignored. Rules themselves can have sub-rules. A rule with sub-rules matches if the rule itself matches and at least one of its sub-rules matches. This recursively applies to all rules and their sub-rules.

## Table of Contents
* Declaring routes
* Rule types
  * URI rules
  * Host rules
  * Path rules
  * Query rules
* Compound rules
* Nested rules
* Forbidden rules 

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
A URI rule takes either a `String` or a `Regexp` and compares it with `uri.host` by calling `#matches?`.

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
The behaviour of path rules depends on whether [mustermann](https://github.com/rkh/mustermann) has been required. When required, you can match path segments and you have access to a `params` hash inside your instance methods. Otherwise, paths are matched as Strings, character by character.

__NOTE:__ mustermann only runs on MRI.

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
The following query rule:

```ruby
draw query: { foo: "bar" }
```
… matches:

* `http://example.com?foo=bar`
* `http://example.com/baz?foo=bar&bar=qux`

… does not match:

* `http://example.com?foo=BAR`

#### Integers
The following query rule:

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
The following query rule:

```ruby
draw query: { foo: /bar/ }
```
… matches:

* `http://example.com?foo=bar`
* `http://example.com/baz?foo=foobar`

… does not match:

* `http://example.com?foo=baz`

#### Ranges
The following query rule:

```ruby
draw query: { foo: 24..42 }
```
… matches:

* `http://example.com?foo=32`
* `http://example.com/baz?foo=40`

… does not match:

* `http://example.com?foo=44`
* `http://w3c.org?foo=22`

#### Compound query constraints
The following query rule:

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

## Forbidden rules