# frozen_string_literal: true
require_relative "../lib/wayfarer"

Wayfarer.log.level = :debug

class FindFoobar < Wayfarer::Job
  let(:keywords) { [] }

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Foobar/
      puts "Foobar! @ #{page.uri}"
      halt
    else
      keywords << page.keywords
      stage page.links
    end
  end
end

FindFoobar.perform_now("https://en.wikipedia.org/wiki/Special:Random")
