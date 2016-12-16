# frozen_string_literal: true
require_relative "../lib/wayfarer"

# Wayfarer.log.level = :debug

class FindFoobar < Wayfarer::Job
  let(:keywords) { [] }

  config.connection_count = 32

  draw host: "en.wikipedia.org"
  def article
    stage page.links
  end
end

FindFoobar.perform_now("https://en.wikipedia.org/wiki/Special:Random")
