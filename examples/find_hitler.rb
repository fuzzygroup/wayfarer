require_relative "../lib/wayfarer"

Wayfarer.log.level = Logger::ERROR

class FindHitler < Wayfarer::Job
  config.connection_count = 16

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Hitasdfsadfler/
      log "Found the dictator at #{page.uri}"
      halt
    else
      visit page.links("a")
      log "No trace of Hitler at #{page.uri}"
    end
  end
end

# FindHitler.crawl("https://en.wikipedia.org/wiki/Special:Random")
