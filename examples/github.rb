require_relative "../lib/schablone"

Crawler = Schablone::Crawler.new do
  uri_template :foobar, ""

  config do |config|
    config.log_level     = Logger::INFO
    config.threads       = 16
    config.http_adapter  = :selenium
    config.selenium_argv = [:phantomjs]
  end

  index :page do
    puts page.headers
    visit page.links
    index :foobar
  end

  index :foobar do
    puts "lel"
  end

  router.draw :page, host: /zeit.de/
end

Crawler.crawl("http://zeit.de")