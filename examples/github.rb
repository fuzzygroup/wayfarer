require_relative "../lib/schablone"
require "mustermann"

class WikipediaTask < Schablone::Task
  config do |config|
    config.scraper_thread_count = 12
    config.reraise_exceptions = true
    config.print_stacktraces = true
  end

  routes do
    draw :index,   host: /pizza.de/
    draw :example, host: "example.com"
  end

  post_process :collect

  def self.collect
    puts "IM SO RUNNING."
  end

  def index
    return halt
    visit page.links "a"
  end

  def example
    "foobarz"
  end
end

puts WikipediaTask.crawl "http://pizza.de/70173"