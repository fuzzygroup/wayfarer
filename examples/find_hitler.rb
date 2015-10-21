require_relative "../lib/wayfarer"

class FindHitler < Wayfarer::Job
  Wayfarer.log.level = Logger::DEBUG
  config.connection_count = 8

  let(:pages) { [] }

  draw host: "en.wikipedia.org"
  def article
    pages << "lel"
    puts pages.count

    if page.body =~ /Hitler/
      #log "Found the dictator at #{page.uri}"
      halt
    else
      stage page.links
      #log "No trace of Hitler at #{page.uri}"
    end
  end
end

FindHitler.crawl("https://en.wikipedia.org/wiki/Special:Random")