require_relative "../lib/schablone"

class MyCrawler
  include Scrapespeare::Crawler

  @reviews = ThreadSafe::Array.new

  draw host: /*/

  def index
    puts "I'm here: #{page.uri}"
    page.links "a"
  end

  private
end

MyTask.crawl "http://zeit.de"
MyTask.reviews
