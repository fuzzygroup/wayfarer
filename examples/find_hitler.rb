# frozen_string_literal: true
require_relative "../lib/wayfarer"

class FindHitler < Wayfarer::Job
  config.connection_count = 32
  # config.reraise_exceptions = true
  config.print_stacktraces = false

  before_crawl do
  end

  after_crawl do
    require "pry"; binding.pry
  end

  let(:hits) { [] }

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Hitler/
      puts "Found the dicator @ #{page.uri}"
      halt
    else
      hits << page.uri
      stage page.links
    end
  end
end

FindHitler.perform_now("https://en.wikipedia.org/wiki/Special:Random")
