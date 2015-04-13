require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  handle :page do
    if page.title ~= /Hitler/
      puts "Found Hitler after #{history.count} attempts!"
      halt
    end

    extract! do
      css :title, "title"
    end

    visit links.sample
  end

  router do
    map :page { path "/" }
  end
end

crawler.process :page do |page|
  
end

crawler.crawl
