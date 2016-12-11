require_relative "../lib/wayfarer"

class FindHitler < Wayfarer::Job
  config.connection_count = 16

  after_crawl do
    puts "I found Hitler at #{hits.first}"
  end

  draw host: "en.wikipedia.org"
  def article
    puts "ARTICLE!"
    if page.body =~ /Hitler/
      halt
    else
      stage page.links
    end
  end
end

FindHitler.perform_now("https://en.wikipedia.org/wiki/Special:Random")
