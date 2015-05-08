require_relative "../lib/schablone"

Crawler = Schablone::Crawler.new do
  helpers do
    
  end

  scrape :index do
    puts page.links
  end

  router.draw(:index) { host "example.com" }
end

Crawler.crawl("http://example.com")
