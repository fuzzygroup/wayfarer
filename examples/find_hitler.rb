require_relative "../lib/wayfarer"

class FindHitler < Wayfarer::Job
  Wayfarer.log.level = Logger::DEBUG
  config.connection_count = 8
  config.frontier = :redis

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Hitler/
      log "Found the dictator at #{page.uri}"
      halt
    else
      stage page.links
      log "No trace of Hitler at #{page.uri}"
    end
  end
end

# FindHitler.crawl("https://en.wikipedia.org/wiki/Special:Random")
