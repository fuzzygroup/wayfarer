require "rspec/core/rake_task"
require "cucumber/rake/task"
require "yard"
require "rack"

namespace(:spec) do
  desc "Run environment-agnostic examples"
  RSpec::Core::RakeTask.new(isolated: [:start_http_server]) do |task|
    task.rspec_opts = %w(--tag ~live)
  end

  desc "Run examples that require a live environment"
  RSpec::Core::RakeTask.new(live: [:start_http_server]) do |task|
    task.rspec_opts = %w(--tag live)
  end
end

Cucumber::Rake::Task.new(features: [:start_http_server])

# Make sure the HTTP server thread gets terminated
%w(spec:isolated spec:live features).each do |task|
  Rake::Task[task].enhance { Rake::Task["stop_http_server"].invoke }
end

YARD::Rake::YardocTask.new(:doc)

task(:build) do
  sh "gem build scrapespeare.gemspec"
end

task(:todos) do
  sh %(grep -rn "# \\(FIXME\\|TODO\\)" .)
end

task(:start_http_server) do
  @http_server_thread = Thread.new do
    Rack::Handler::WEBrick.run Rack::File.new(
      File.expand_path("../support/www", __FILE__)
    )
  end
end

task(:stop_http_server) do
  @http_server_thread.kill
end
