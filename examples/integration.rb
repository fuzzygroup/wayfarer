require_relative "../lib/wayfarer"

class Integration < Wayfarer::Job
  config.connection_count = 4
  config.reraise_exceptions = true
  config.frontier = :sidekiq

  let(:counter) { 0 }

  draw host: /./
  def article
    return halt if locals[:counter] == 100
    stage page.links
    locals[:counter] += 1
  end
end
