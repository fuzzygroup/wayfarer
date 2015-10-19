require "wayfarer"

class FindHitler < Wayfarer::Job
  config.connection_count = 8

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
