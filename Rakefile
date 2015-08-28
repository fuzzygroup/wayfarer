require "rspec/core/rake_task"
require "rubocop/rake_task"
require "rack"

require_relative "support/test_app"

namespace :spec do
  desc "Run only environment-agnostic tests"
  RSpec::Core::RakeTask.new isolated: [:test_app] do |task|
    task.rspec_opts = ["--tag ~live"]
  end

  desc "Run only tests that require a live environment"
  RSpec::Core::RakeTask.new live: [:test_app] do |task|
    task.rspec_opts = ["--tag live"]
  end

  desc "Run only JRuby tests"
  RSpec::Core::RakeTask.new jruby: [:test_app] do |task|
    task.rspec_opts = ["--tag ~mri --tag ~live --tty"]
  end

  desc "Run only MRI tests"
  RSpec::Core::RakeTask.new mri: [:test_app] do |task|
    task.rspec_opts = ["--tag ~mri --tag ~live"]
  end
end

desc "Run all tests"
RSpec::Core::RakeTask.new(spec: :test_app)

RuboCop::RakeTask.new do |task|
  task.formatters = ["simple"]
end

desc "Build the RubyGem"
task :build do
  sh "gem build wayfarer.gemspec --verbose"
end

desc "Start a Ruby shell"
task :shell do
  require_relative "lib/schablone"

  include Wayfarer
  include Wayfarer::HTTPAdapters
  include Wayfarer::Routing

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
  sh %(grep -rn "\\(FIXME\\|TODO\\)" lib spec | tr -s [:space:])
end

# Private
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
      StartCallback: proc { cvar.signal }
    )
  end

  mutex.lock
  cvar.wait(mutex)
end
