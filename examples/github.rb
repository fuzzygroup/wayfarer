require_relative "../lib/schablone"

Crawler = Schablone::Crawler.new do
  config do |config|
    config.log_level     = Logger::INFO
    config.thread_count  = 16
    # config.http_adapter  = :selenium
    config.selenium_argv = [:firefox]
  end

  index :foo do
    # puts page.uri
    visit page.links
  end

  router.draw :foo, host: /zeit.de/
end

Crawler.crawl("http://zeit.de")
