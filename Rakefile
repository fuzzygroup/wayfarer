require "rspec/core/rake_task"
require "rubocop/rake_task"
require "rack"

require_relative "support/test_app"

namespace :test do
  desc "Run only environment-agnostic tests"
  RSpec::Core::RakeTask.new isolated: [:test_app] do |task|
    task.rspec_opts = ["--tag ~selenium --tag ~redis"]
  end

  desc "Run only Selenium tests"
  RSpec::Core::RakeTask.new selenium: [:test_app] do |task|
    task.rspec_opts = ["--tag selenium"]
  end

  desc "Run only Redis tests"
  RSpec::Core::RakeTask.new redis: [:test_app] do |task|
    task.rspec_opts = ["--tag redis"]
  end
end

desc "Run all tests"
RSpec::Core::RakeTask.new(test: :test_app)

RuboCop::RakeTask.new do |task|
  task.formatters = ["simple"]
end

desc "Build the RubyGem"
task :build do
  sh "gem build wayfarer.gemspec --verbose"
  sh "mkdir -p build"
  sh "mv wayfarer-*.gem build"
end

desc "Install the RubyGem"
task :install do
  sh "gem uninstall wayfarer"
  sh "gem install build/*.gem"
end

desc "Remove build/ directory"
task :clean do
  sh "rm -rf build"
end

desc "Start a Ruby shell"
task :shell do
  require_relative "lib/wayfarer"

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
