require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do

  scraper :page do
    if page.title ~= /Hitler/
      puts "Found Hitler after #{history.count} attempts!"
      halt
    end
    visit links
  end

  router do
    map :page { path "/" }
  end
end

result = crawler.crawl(URI("http://de.wikipedia.org/wiki/Wikipedia:Hauptseite"))
