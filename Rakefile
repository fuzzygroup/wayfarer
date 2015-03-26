require "rspec/core/rake_task"
require "cucumber/rake/task"
require "rubocop/rake_task"
require "yard"
require "rack"

require_relative "support/test_app"

# ==============================================================================
# RSpec
# ==============================================================================
namespace :spec do
  desc "Run environment-agnostic examples"
  RSpec::Core::RakeTask.new isolated: [:start_test_app] do |task|
    task.rspec_opts = ["--tag ~live"]
  end

  desc "Run examples that require a live environment"
  RSpec::Core::RakeTask.new live: [:start_test_app] do |task|
    task.rspec_opts = ["--tag live"]
  end
end

desc "Run all examples"
task spec: ["spec:isolated", "spec:live"]

# ==============================================================================
# Cucumber
# ==============================================================================
namespace :features do
  desc "Run environment-agnostic scenarios"
  Cucumber::Rake::Task.new isolated: [:start_test_app] do |task|
    task.cucumber_opts = ["--format progress"]
  end
end

desc "Run all scenarios"
task features: ["features:isolated"]

# ==============================================================================
# RuboCop
# ==============================================================================
RuboCop::RakeTask.new do |task|
  task.formatters = ["simple"]
end

# ==============================================================================
# YARD
# ==============================================================================
YARD::Rake::YardocTask.new :doc

# ==============================================================================
# RubyGems
# ==============================================================================
desc "Build RubyGem"
task :build do
  sh "gem build schablone.gemspec --verbose"
end

# ==============================================================================
# Plumbing
# ==============================================================================
desc %(List lines that contain "FIXME" or "TODO")
task :todo do
  sh %(grep -rn "\\(FIXME\\|TODO\\)" lib spec features | tr -s [:space:])
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

# ==============================================================================
# Test web app
# ==============================================================================
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

["spec:isolated", "spec:live", "features"].each do |task|
  Rake::Task[task].enhance { Rake::Task["stop_test_app"].invoke }
end
