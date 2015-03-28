require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  config.log_level = Logger::INFO
  config.threads = 4

  scraper do
    css :title, "title"
  end

  router.allow do
    host /heise.de/
  end
end

result = crawler.crawl(URI("http://heise.de"))
