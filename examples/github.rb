require_relative "../lib/schablone"
require "securerandom"
require "concurrent"

Celluloid.task_class = Celluloid::TaskThread

Schablone.config do |c|
  c.scraper_pool_size = 3
  c.allow_circulation = true
end

class MyCrawler < Schablone::Task
  @@counter = Concurrent::AtomicFixnum.new(0)

  draw host: /.*/
  def website
    halt! if @@counter.value == 5
    visit page.links("a").sample(4)
    @@counter.increment
  end
end

MyCrawler.crawl("https://news.ycombinator.com/")
