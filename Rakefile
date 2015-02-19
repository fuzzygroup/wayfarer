require "rspec/core/rake_task"
require "cucumber/rake/task"
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
    task.cucumber_opts = "features --format progress"
  end
end

desc "Run all scenarios"
task features: %w(features:isolated)

# Make sure the HTTP server thread gets terminated
%w(spec:isolated spec:live features).each do |task|
  Rake::Task[task].enhance { Rake::Task["stop_test_app"].invoke }
end

YARD::Rake::YardocTask.new :doc

desc "Build the RubyGem"
task :build do
  sh "gem build scrapespeare.gemspec --verbose"
end

desc "List hi"
task(:todo) do
  sh %(grep -rn "\\(FIXME\\|TODO\\)" lib spec features | tr -s [:space:])
end

task(:start_test_app) do
  @httpd = Thread.new { Rack::Handler::WEBrick.run TestApp }
end

task(:stop_test_app) do
  @httpd.kill
end
