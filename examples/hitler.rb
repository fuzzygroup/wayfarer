require "wayfarer"
require "mustermann"

class DummyJob < Wayfarer::Job
  config.connection_count = 16

  routes do
    draw :article, host: "en.wikipedia.org", path: "/wiki/:article"
  end

  def article
    if page.body =~ /Hitler/
      puts "Found the dictator at #{page.uri}"
      halt
    else
      visit page.links("a")
      puts "No trace of Hitler at #{page.uri}"
    end
  end
end

DummyJob.crawl("https://en.wikipedia.org/wiki/Special:Random")
