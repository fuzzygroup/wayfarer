require_relative "../lib/schablone"
require "securerandom"

Schablone.config do |c|
  c.scraper_pool_size = 3
  c.http_adapter = :selenium
  c.allow_circulation = true
end

class MyCrawler < Schablone::Task
  let(:reviews) { [] }

  draw host: /.*/
  def website
    filename = SecureRandom.uuid
    browser.save_screenshot "/Users/dom/Desktop/screenshots/#{filename}.png"
    visit page.links("a").sample(4)
  end
end

MyCrawler.crawl("https://news.ycombinator.com/")
