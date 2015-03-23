require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do

  config.log_level = Logger::INFO

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