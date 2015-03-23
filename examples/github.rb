require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do

  config.log_level = Logger::INFO

  scraper do
    css :title, "title"
    css :headings, "h1"
  end

  router.allow do
    host /.de/
  end

end

result = crawler.crawl(URI("http://faz.de"))
puts result