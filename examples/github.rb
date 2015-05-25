require_relative "../lib/schablone"
require "rethinkdb"

Crawler = Schablone::Crawler.new({}) do |result|
  config do
    
  end

  uri "http://yelp.com/:id/"

  helpers do
    def conn
      @conn ||= r.connect(host: "localhost", port: 28015)
    end

    def venues
      css :venues
    end

    def review_id
      css review_id: ".review .id", :content!
    end
  end

  scrape :foobar do
  end

  route.draw :foobar, host: "reddit.com"
end

result = Crawler.crawl("http://pizza.de/81479")
