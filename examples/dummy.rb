require_relative "../lib/wayfarer"

class DummyJob < Wayfarer::Job
  routes do
    draw :overview, host: "github.com", path: "/:user/:repo"
    draw :issues,   host: "github.com", path: "/:user/:repo/issues"
  end

  def overview
    visit "https://github.com/rails/rails/issues"
  end

  def issues
    puts "Rails got some issues."
  end
end

DummyJob.crawl("https://github.com/rails/rails")
