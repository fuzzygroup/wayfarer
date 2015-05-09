require_relative "../lib/schablone"

Crawler = Schablone::Crawler.new do
  helpers do
    def nodes
    end

    def edges
    end

    def save
      browser.execute_javascript
    end
  end

  scrape :page do
    save nodes
    save edges
    visit page.links
  end

  router.draw :page, host: /zeit.de/
end

Crawler.crawl("http://zeit.de")
