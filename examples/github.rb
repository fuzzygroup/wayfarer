require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do

  config.log_level = Logger::INFO
  config.threads = 32

  scraper do
    css :title, "title"
    css :headings, "h1"
  end

  router.allow do
    host /zeit.de/
  end

end

result = crawler.crawl(URI("http://zeit.de"))
puts result