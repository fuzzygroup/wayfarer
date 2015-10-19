require_relative "../lib/wayfarer"

class ActiveJobExample < Wayfarer::Job
  config.connection_count = 16

  draw host: "en.wikipedia.org"
  def article
    if page.body =~ /Hitler/
      puts "Found the dictator at #{page.uri}"
      halt
    else
      visit page.links("a")
      puts "No trace of Hitler at #{page.uri}"
    end
  end
end
