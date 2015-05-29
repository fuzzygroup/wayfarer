require_relative "../lib/schablone"

class MyTask < Schablone::Task
  def foobar
    barfoo(123)
  end

  def something
  end

  def barfoo(arg)
    puts arg
  end

  routes.draw :foobar, host "example.com"
end

MyTask.invoke
