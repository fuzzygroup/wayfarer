Given(/^a Crawler$/) do
  @crawler = Scrapespeare::Crawler.new
end

Given(/^the following Scraper:$/) do |code|
  @crawler.define_scraper { eval(code) }
end

When(/^I crawl "(.*?)"$/) do |path|
  uri = "http://localhost:8080/#{path}"
  @result = @crawler.crawl(uri)
end

Then(/^I get the following Result:$/) do |code|
  expect(@result.to_h).to eq eval(code)
end
