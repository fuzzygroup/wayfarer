require "thread_safe"
require_relative "../lib/schablone"

class MyCrawler < Schablone::Task
  @reviews = ThreadSafe::Array.new

  draw host: /zeit.de/

  def index
    @reviews << "HELLO!"
    puts "I'm here: #{page.uri}"
    page.links "a"
  end

  private

  def review_title
    doc.search("LEL")
  end
end

MyCrawler.crawl "http://zeit.de"
