Before do
  stub_request(:get, "http://example.com").to_return(
    body: example_html("index.html")
  )
end

Given(/^a website$/) do
  @uri = "http://example.com"
end

Given(/^the following Crawler:$/) do |code|
  @crawler = Scrapespeare::Crawler.new { scrape { eval(code) } }
end

When(/^I crawl the website$/) do
  @result = @crawler.crawl(@uri)
end

Then(/^I get the following result:$/) do |code|
  expected_result = eval(code)
  expect(@result).to eq expected_result
end
