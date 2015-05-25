require_relative "../lib/schablone"

Crawler = Schablone do
  let(:data) { Hash.new }

  config do
    
  end

  helpers do
    def levenshtein_distance(str_a, str_b)
    end
  end
end

result = Crawler.crawl("http://google.com")
result.data
