require_relative "../lib/wayfarer"

class DummyJob < Wayfarer::Job
  routes do
    draw :foo, uri: "http://google.com"

    draw :bar, host: "google.com"
    draw :baz, host: /google/

    draw :qux, path: "/foo/bar"
  end

  def foo; end
  def bar; end
end
