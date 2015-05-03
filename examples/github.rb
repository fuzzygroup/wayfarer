require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  handle :index, with: :net_http do
    puts extract { css :title, "title" }
    visit page.uri { query += 1 }
  end

  handle :issues do
    puts extract { css :title, "title" }
  end

  router.map(:foobar) do
    host "google.com", paths: "/foo", "/bar", "**/*.png"
  end

  router.map(:index, host: "github.com", path: "/intridea/hashie")
  router.map(:issues) { host "github.com", path: "/intridea/hashie/issues" }
end

crawler.crawl(URI("https://github.com/intridea/hashie"))
