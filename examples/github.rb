require_relative "../lib/schablone"

Schablone.config.log_level = Logger::INFO

Crawler = Schablone::Crawler.new do
  index :page do
    puts page.title
    visit page.links
  end

  router do
    within host: "github.com", path: "/bauerd/repo" do
      draw :
    end
  end
end

result = Crawler.crawl("http://zeit.de")
