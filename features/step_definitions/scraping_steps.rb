Before { WebMock.disable_net_connect!(allow_localhost: true) }

Given(/^the dummy website "(.*?)"$/) do |file_name|
  @uri = "http://localhost:8080/#{file_name}"
end

Given(/^a Crawler$/) do
  @crawler = Scrapespeare::Crawler.new
end

Given(/^the following Scraper:$/) do |code|
  @crawler.scrape { eval(code) }
end

When(/^I crawl the website$/) do
  @result = @crawler.crawl(@uri)
end

Then(/^I get the following result:$/) do |code|
  expected_result = eval(code)
  expect(@result).to eq expected_result
end
