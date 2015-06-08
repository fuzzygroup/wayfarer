require_relative "../lib/schablone"

Celluloid.task_class = Celluloid::TaskThread

class MyTask < Schablone::Task
  routes do
    draw :foo, host: /zeit.de/
    draw :bar, host: "zeit.de"
  end

  def foo
    params[0]
    page.links

    Model.save(articles)
  end

  private

  def articles
    css :articles do
      css :heading, "h1"
      css :foobar, "a.bar"
    end
  end

  def headlines
    css :headlines, "h1"
  end

  def interesting_links
    page.links css: ["a.next", "a.foo"]
  end
end

MyTask.crawl "http://0.0.0.0:9876"

