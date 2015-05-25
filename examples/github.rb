require_relative "../lib/schablone"

Schablone.config.log_level = Logger::INFO

Crawler = Schablone do
  scrape :page do
    puts page.title
    visit page.links
  end

  router.draw :page do
    host "google.com"
  end
end

result = Crawler.crawl("http://google.com")

