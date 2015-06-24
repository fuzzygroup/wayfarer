require_relative "../lib/schablone"
require "mustermann"

class WikipediaTask < Schablone::Task
  config do |config|
    config.scraper_thread_count = 12
    config.reraise_exceptions = true
    config.print_stacktraces = true
    config.http_adapter = :selenium
    config.selenium_argv = :phantomjs
  end

  routes do
    within host: "pizza.de" do
      draw :index, path: "/:zipcode"
      draw :detail, path: "/:zipcode", query: { lgs: "36294" }
    end
  end

  post_process :collect

  def self.collect
  end

  def index
    foo = yield page.links "a.important"
    visit page.links "a"
  end

  def detail
  end
end

puts WikipediaTask.crawl "http://http://pizza.de/70173"