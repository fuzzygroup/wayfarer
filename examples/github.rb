require_relative "../lib/schablone"
require "rethinkdb"

Crawler = Schablone::Crawler.new do
  DATABASE = "dominic"
  TABLE    = :zeit

  helpers RethinkDB::Shortcuts

  helpers do
    def conn
      @conn ||= r.connect(host: "localhost", port: 28015)
    end

    def venues
      css :venues
    end
  end

  #r.db(DATABASE).table(TABLE).insert(extract).run(conn)
  #conn.close

  scrape :page do
    
  end

  router.draw(:page) { host "pizza.de" }
end

Crawler.crawl("http://pizza.de/81479")
