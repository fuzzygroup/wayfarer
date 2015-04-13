require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  handle :page do
    puts page.uri
  end

  router.map(:page) { host "de.wikipedia.org" }
end

crawler.listen :page do |page|
  puts page
end

crawler.crawl(URI("http://de.wikipedia.org/wiki/Fubar"))
