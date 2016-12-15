# frozen_string_literal: true
require_relative "../lib/wayfarer"

class FindFoobar < Wayfarer::Job
  let(:hits) { [1, 2, 3] }

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Foobar/
      puts "Foobar! @ #{page.uri}"
      halt
    else
      stage page.links
    end
  end
end

FindFoobar.perform_now("https://en.wikipedia.org/wiki/Special:Random")
