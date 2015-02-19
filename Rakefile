require "rspec/core/rake_task"
require "cucumber/rake/task"
require "yard"
require "rack"

namespace(:spec) do
  desc "Run environment-agnostic examples"
  RSpec::Core::RakeTask.new(isolated: [:start_httpd]) do |task|
    task.rspec_opts = %w(--tag ~live)
  end

  desc "Run examples that require a live environment"
  RSpec::Core::RakeTask.new(live: [:start_httpd]) do |task|
    task.rspec_opts = %w(--tag live)
  end
end

Cucumber::Rake::Task.new(features: [:start_httpd]) do |task|
  task.cucumber_opts = "features --format progress"
end

# Make sure the HTTP server thread gets terminated
%w(spec:isolated spec:live features).each do |task|
  Rake::Task[task].enhance { Rake::Task["stop_httpd"].invoke }
end

YARD::Rake::YardocTask.new(:doc)

task(:build) do
  sh "gem build scrapespeare.gemspec"
end

task(:todo) do
  sh %(grep -rn "# \\(FIXME\\|TODO\\)" lib | tr -s [:space:])
end

task(:start_httpd) do
  @httpd = Thread.new do
    Rack::Handler::WEBrick.run Rack::File.new(
      File.expand_path("../support/www", __FILE__)
    )
  end
end

task(:stop_httpd) do
  @httpd.kill
end
