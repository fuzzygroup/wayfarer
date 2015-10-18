require_relative "../lib/wayfarer"

class FindHitler < Wayfarer::Job
  config.connection_count = 8
  config.http_adapter = :selenium
  config.selenium_argv = [:phantomjs]

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Hitler/
      log "Found the dictator at #{page.uri}"
      halt
    else
      driver.save_screenshot("/tmp/scrns/#{Time.now.to_i}.png")
      visit page.links("a")
      log "No trace of Hitler at #{page.uri}"
    end
  end
end

# FindHitler.crawl("https://en.wikipedia.org/wiki/Special:Random")
