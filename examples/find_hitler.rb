require_relative "../lib/wayfarer"

class FindHitler < Wayfarer::Job
  config.connection_count = 2

  after_crawl do
    puts "I found Hitler at #{hits.first}"
  end

  let(:hits) { [] }

  draw host: "en.wikipedia.org"
  def article
    require "pry"; binding.pry
    if page.body =~ /Hitler/
      puts "Found the dicator @ #{page.uri}"
      halt
    else
      puts "No trace of Hitler @ #{page.uri}"
      stage page.links
    end
  end
end

FindHitler.perform_now("https://en.wikipedia.org/wiki/Special:Random")
