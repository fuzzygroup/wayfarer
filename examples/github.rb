require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do

  scraper do
    if page.title ~= /Hitler/
      puts "Found Hitler after #{history.count} attempts!"
    end

    visit links
  end

  router.map :page do
    host "wikipedia.org", path: "/wiki"
  end
end

result = crawler.crawl(URI("http://de.wikipedia.org/wiki/Wikipedia:Hauptseite"))
