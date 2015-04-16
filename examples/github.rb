require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  config.http_adapter = :selenium

  handle :index do
    puts extract { css :title, "title" }
    visit page.links
  end

  handle :issues do
    puts extract { css :title, "title" }
  end

  router.map(:index)  { host "github.com", path: "/intridea/hashie" }
  router.map(:issues) { host "github.com", path: "/intridea/hashie/issues" }
end

crawler.crawl(URI("https://github.com/intridea/hashie"))
