require_relative "../lib/wayfarer"

class FindHitler < Wayfarer::Job
  config.connection_count = 2
  # config.reraise_exceptions = true
  config.print_stacktraces = false

  before_crawl do
    # require "pry"; binding.pry
  end

  after_crawl do
  end

  let(:hits) { [] }

  draw host: "en.wikipedia.org"
  def article
    fail "FUCK"
    if page.body =~ /Hitler/
      puts "Found the dicator @ #{page.uri}"
      halt
    else
      puts "No trace of Hitler @ #{page.uri}"
      hits << page.url
      stage page.links
    end
  end
end

FindHitler.perform_now("https://en.wikipedia.org/wiki/Special:Random")
