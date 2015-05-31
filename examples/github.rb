require_relative "../lib/schablone"

Celluloid.task_class = Celluloid::TaskThread

class MyTask < Schablone::Task
  def foo
    
  end

  route.draw :foo, host: /zeit.de/
end

MyTask.crawl "http://zeit.de"
