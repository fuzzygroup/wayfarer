require_relative "../lib/schablone"

Crawler = Schablone do
  scrape :page do
    puts page.title
    visit page.links
    puts @processor.navigator.staged_uris
  end

  router.draw :page do
    host "zeit.de"
  end
end

result = Crawler.crawl("http://zeit.de")

