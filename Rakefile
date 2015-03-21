require "rspec/core/rake_task"
require "cucumber/rake/task"
require "rubocop/rake_task"
require "yard"
require "rack"

require_relative "support/test_app"

namespace :spec do
  desc "Run environment-agnostic examples"
  RSpec::Core::RakeTask.new isolated: [:start_test_app] do |task|
    task.rspec_opts = %w(--tag ~live)
  end

  desc "Run examples that require a live environment"
  RSpec::Core::RakeTask.new live: [:start_test_app] do |task|
    task.rspec_opts = %w(--tag live)
  end
end

desc "Run all examples"
task spec: %w(spec:isolated spec:live)

namespace :features do
  desc "Run environment-agnostic scenarios"
  Cucumber::Rake::Task.new isolated: [:start_test_app] do |task|
    # task.cucumber_opts = "features" # --format progress
  end
end

desc "Run all scenarios"
task features: ["features:isolated"]

%w(spec:isolated spec:live features).each do |task|
  Rake::Task[task].enhance { Rake::Task["stop_test_app"].invoke }
end

RuboCop::RakeTask.new do |task|
  task.formatters = ["clang"]
end

YARD::Rake::YardocTask.new :doc

desc "Build the RubyGem"
task :build do
  sh "gem build scrapespeare.gemspec --verbose"
end

desc %(List lines that contain "FIXME" or "TODO")
task :todo do
  sh %(grep -rn "\\(FIXME\\|TODO\\)" lib spec features | tr -s [:space:])
end

desc "Start a Ruby shell"
task :shell do
  require_relative "lib/scrapespeare"

  include Scrapespeare
  include Scrapespeare::Routing

  begin
    require "pry"
    binding.pry(quiet: true)
  rescue LoadError
    require "irb"
    ARGV.clear
    IRB.start
  end
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

task :start_test_app do
  @server_thread = Thread.new { Rake::Task["run_test_app"].execute }
  sleep(0.5)
end

task :stop_test_app do
  @server_thread.kill
end
