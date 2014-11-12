task default: :spec

namespace :spec do

  desc "Run all examples that do not require a network connection"
  task :offline do
    sh "bundle exec rspec . --tag ~live"
  end

  desc "Run all examples that require a network connection"
  task :online do
    sh "bundle exec rspec . --tag live"
  end

  desc "Run all examples"
  task :all do
    sh "bundle exec rspec"
  end
end

desc "Build the gem"
task :build do
  sh "gem build scrapespeare.gemspec"
end

desc "Generate source code documentation"
task :doc do
  sh "yard doc"
end
