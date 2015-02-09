Before do
  stub_request(:get, "http://example.com").to_return(
    body: html("index.html")
  )
end

Given(/^a website$/) do
  @uri = "http://example.com"
end

Given(/^the following Scraper:$/) do |code|
  @crawler = Scrapespeare::Crawler.new do
    eval(code)
  end
end

When(/^I scrape the website$/) do
  @result = @scraper.scrape(@uri)
end

Then(/^I get the following result:$/) do |code|
  expected_result = eval(code)
  expect(@result).to eq expected_result
end
