Before { WebMock.disable_net_connect!(allow_localhost: true) }

Given(/^a Crawler$/) do
  @crawler = Scrapespeare::Crawler.new
end

Given(/^the following Scraper:$/) do |code|
  @crawler.scrape { eval(code) }
end

When(/^I crawl "(.*?)"$/) do |path|
  uri = "http://localhost:8080/#{path}"
  @result = @crawler.crawl(uri)
end

Then(/^I get the following result:$/) do |code|
  expected_result = eval(code)
  expect(@result).to eq expected_result
end
