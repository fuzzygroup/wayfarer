require "rspec/core/rake_task"
require "rubocop/rake_task"
require "rack"

require_relative "support/test_app"

namespace :spec do
  desc "Run environment-agnostic examples"
  RSpec::Core::RakeTask.new isolated: [:test_app] do |task|
    task.rspec_opts = ["--tag ~live"]
  end

  desc "Run examples that require a live environment"
  RSpec::Core::RakeTask.new live: [:test_app] do |task|
    task.rspec_opts = ["--tag live"]
  end

  desc "Run all JRuby examples"
  RSpec::Core::RakeTask.new jruby: [:test_app] do |task|
    task.rspec_opts = ["--tag ~mri --tag ~live --tty"]
  end

  desc "Run all MRI examples"
  RSpec::Core::RakeTask.new mri: [:test_app] do |task|
    task.rspec_opts = ["--tag ~mri --tag ~live"]
  end
end

desc "Run all examples"
RSpec::Core::RakeTask.new spec: :test_app

RuboCop::RakeTask.new do |task|
  task.formatters = ["simple"]
end

desc "Build RubyGem"
task :build do
  sh "gem build schablone.gemspec --verbose"
end

desc "Start a Ruby shell"
task :shell do
  require_relative "lib/schablone"

  include Schablone
  include Schablone::Extraction
  include Schablone::Routing

  begin
    require "pry"
    Pry.new.repl(self)
  rescue LoadError
    require "irb"
    ARGV.clear
    IRB.start
  end
end

desc %(List lines that contain "FIXME" or "TODO")
task :todo do
  sh %(grep -rn "\\(FIXME\\|TODO\\)" lib spec features | tr -s [:space:])
end

task :run_test_app do
  Rack::Handler::WEBrick.run(
    TestApp,
    Port: 9876,
    BindAddress: "localhost",
    Logger: WEBrick::Log.new("/dev/null"),
    AccessLog: []
  )
end

task :test_app do
  mutex = Mutex.new
  cvar  = ConditionVariable.new

  @server_thread ||= Thread.new do
    Rack::Handler::WEBrick.run(
      TestApp,
      Port: 9876,
      BindAddress: "localhost",
      Logger: WEBrick::Log.new("/dev/null"),
      AccessLog: [],
      :StartCallback => Proc.new { cvar.signal }
    )
  end

  mutex.lock
  cvar.wait(mutex)
end

["spec:isolated", "spec:live", "spec:mri", "spec:jruby"].each do |task|
  Rake::Task[task].enhance { Rake::Task["stop_test_app"].invoke }
end
