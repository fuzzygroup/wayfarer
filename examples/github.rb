require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  config.log_level = Logger::INFO
  config.threads = 32

  scraper do
    css :title, "title"
  end

  router.allow do
  end
end

result = crawler.crawl(URI("http://zeit.de"))
puts result
