require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  handle :page do
    if page.title ~= /Hitler/
      puts "Found Hitler after #{history.count} attempts!"
      halt
    end

    extract do
      
    end

    visit links.sample
  end

  router do
    map :page { path "/" }
  end
end

crawler.crawl(uri) do |extract|
  
end
