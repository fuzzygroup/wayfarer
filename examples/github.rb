require_relative "../lib/schablone"

class WikipediaTask < Schablone::Task
  draw host: /wikipedia.org/
  def wikipedia_page
    title = doc.search("title").inner_html
    puts "I'm here: #{title}"
    visit page.links("a")
  end
end

WikipediaTask.crawl "http://wikipedia.org"