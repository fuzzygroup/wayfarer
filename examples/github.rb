require_relative "../lib/schablone"

Crawler = Schablone::Crawler.new do
  config do |config|
    config.log_level     = Logger::INFO
    config.thread_count  = 16
    config.http_adapter  = :selenium
    config.selenium_argv = [:firefox]
  end

  scrape :index do
    def page
    end
  end

  router.draw :foo, host: "example.com"
end

Crawler.crawl("http://zeit.de")
