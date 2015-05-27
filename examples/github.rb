require_relative "../lib/schablone"

Crawler = Schablone::Crawler.new do
  config do |config|
    config.log_level     = Logger::INFO
    config.threads       = 16
    # config.http_adapter  = :selenium
    config.selenium_argv = [:phantomjs]
  end

  threadsafe :file, File.open("/tmp/foobar", "w")

  index :foo do
    file.puts page.uri
    visit page.links
  end

  router.draw :foo, host: /zeit.de/
end

Crawler.crawl("http://zeit.de")