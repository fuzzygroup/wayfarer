require_relative "../lib/schablone"

Schablone.config.log_level = Logger::INFO

Crawler = Schablone::Crawler.new do
  config do |config|
    config.threads = 8
    config.http_adapter = :selenium
  end

  index :page do
    adapter.driver.save_screenshot "/Users/dom/Desktop/scrnshts/#{Time.now.to_i}.png"
    visit page.links
  end

  router.draw :page, host: /wikipedia.org/
end

result = Crawler.crawl("http://de.wikipedia.org/wiki/Spezial:Zuf%C3%A4llige_Seite")
