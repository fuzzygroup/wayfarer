require_relative "../lib/schablone"

crawler = Schablone::Crawler.new do
  handle :index, with: :net_http do
    puts extract { css :title, "title" }
    visit page.uri { query += 1 }
  end

  handle :issues do
    extract do
      css :elements, ".element" do
        css :title, ".title"
      end
    end
  end

  router.map(:foobar) do
    host "google.com", paths: "/foo", "/bar", "**/*.png"
  end

  router.allow.host "example.com"

  router.map :index, host: "github.com", path: "/intridea/hashie"
  router.map :issues host: "github.com", path: "/intridea/hashie/issues"
end

crawler.crawl(URI("https://github.com/intridea/hashie"))
