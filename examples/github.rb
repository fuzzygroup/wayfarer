require_relative "../lib/schablone"

Crawler = Schablone::Crawler.new do
  uri_template :foobar, ""

  config do |config|
    config.log_level     = Logger::INFO
    config.threads       = 16
    # config.http_adapter  = :selenium
    config.selenium_argv = [:phantomjs]
  end

  helpers do
    
  end

  index :culture do
    params[:article]
  end

  catch_all do
    visit page.links
  end

  router.forbid do
    path ""
  end

  router.draw :culture, host: "zeit.de", path: "/kultur/{article}"
  router.draw :catch_all, host: "zeit.de"
end

Crawler.crawl("http://zeit.de")