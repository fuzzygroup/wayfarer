require_relative "../lib/scrapespeare"

crawler = Schablone::Crawler.new do

  config do
    log_level = Logger::INFO
  end

  scraper do
    css :title, "title"
    css :headings, "h1"
  end

  router.allow do
    uri "http://github.com"
  end

end

result = crawler.crawl(URI("http://github.com"))
puts result