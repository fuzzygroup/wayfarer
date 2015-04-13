require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  scraper :page do
    if page.title ~= /Hitler/
      puts "Found Hitler after #{history.count} attempts!"
      halt
    end

    extract! do
      css :title, "title"
    end

    visit page.links css: "a.next-page"
  end

  router do
    map :page { path "/" }
  end
end

crawler.crawl
