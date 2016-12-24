require_relative "../lib/wayfarer"
require "securerandom"

class CollectGithubIssues < Wayfarer::Job
  config.connection_count = 16
  config.http_adapter = :selenium
  config.selenium_argv = [:phantomjs]
  config.reraise_exceptions = true

  let(:counter) { 0 }

  draw host: "en.wikipedia.org"
  def article
    puts locals[:counter] += 1
    stage page.links
  end
end

CollectGithubIssues.perform_now("https://en.wikipedia.org/wiki/Special:Random")
