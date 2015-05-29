require_relative "../lib/schablone"

class MyTask < Schablone::Task
  def foobar
  end

  def something
  end

  def barfoo
  end

  router.draw :foo, host: "example.com"
end

MyTask.new.invoke
