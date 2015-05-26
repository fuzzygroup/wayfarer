require_relative "../lib/schablone"

Schablone.config.log_level = Logger::INFO

Crawler = Schablone::Crawler.new do
  index :page do
    puts page.title
    visit page.links
  end

  router.draw :page, host: "zeit.de"
end

result = Crawler.crawl("http://zeit.de")
