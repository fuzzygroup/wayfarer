require_relative "../lib/schablone"

Schablone.config.log_level = Logger::INFO

Crawler = Schablone::Crawler.new do
  index :page do
    puts page.title
    visit page.links
  end

  router do
    draw :page do
      host "zeit.de"
    end
  end
end

result = Crawler.crawl("http://zeit.de")
