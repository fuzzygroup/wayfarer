require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  config.log_level = Logger::INFO
  config.threads = 32

  scraper do |doc|
    {
      foo: doc.css("lel").count
    }
  end

  router.allow do
    host /zeit.de/
  end
end

result = crawler.crawl(URI("http://zeit.de"))
puts result
