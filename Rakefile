require "rspec/core/rake_task"
require "cucumber/rake/task"
require "yard"

namespace(:spec) do
  desc "Run examples that do not require a live environment"
  RSpec::Core::RakeTask.new(:isolated) do |task|
    task.rspec_opts = %w(--tag ~live)
  end

  desc "Run examples that require a live environment"
  RSpec::Core::RakeTask.new(:live) do |task|
    task.rspec_opts = %w(--tag live)
  end
end

task(:spec) { Rake::Task["spec:isolated"].invoke }

YARD::Rake::YardocTask.new(:doc)

Cucumber::Rake::Task.new(:features) do |task|
  task.cucumber_opts = %w(--format=progress)
end
