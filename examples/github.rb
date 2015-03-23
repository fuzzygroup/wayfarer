require_relative "../lib/scrapespeare"

crawler = Scrapespeare::Crawler.new do

  config do
    log_level = Logger::INFO
  end

  scraper do
    css :title, "title"
  end

  router.allow do
    uri "http://github.com"
  end

end

result = crawler.crawl(URI("http://github.com"))
puts result