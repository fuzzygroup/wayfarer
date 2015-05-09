require_relative "../lib/schablone"

class Crawler < Schablone::Crawler.new
  before do
  end

  helpers do
    def conn
      @conn ||= RethinkDB.new
    end

    def nodes
    end

    def edges
    end

    def save
      browser.execute_javascript
    end

    def data
      reviews, 
    end

    def reviews
      css persons: ".person" do
        css name: ".name"
      end
      css :address, ".address"
    end
  end

  def page
    save nodes
    save edges
    visit page.links
  end

  router.draw :page, host: /zeit.de/
end

crawler = Crawler.new.crawl("http://zeit.de")
