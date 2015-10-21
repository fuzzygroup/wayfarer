require_relative "../lib/wayfarer"

class FindHitler < Wayfarer::Job
  # Wayfarer.log.level = Logger::DEBUG
  config.connection_count = 16

  let(:hits) { [] }

  after_crawl do
    puts "I found Hitler at #{hits.first}"
  end

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Hitler/
      hits << page.uri
      halt
    else
      stage page.links
    end
  end
end

FindHitler.crawl("https://en.wikipedia.org/wiki/Special:Random")