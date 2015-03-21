require "uri"

Given(/^the following Rule:$/) do |str|
  @rule = Rule.new
  @rule.instance_eval(str)
end

Given(/^the following list of URIs:$/) do |str|
  @uris = str.split("\n").map { |str| URI(str) }
end

When(/^I match the URIs against the Rule$/) do
  @filtered_uris = @uris.find_all { |uri| @rule === uri }
end

Then(/^I get the following list of URIs:$/) do |str|
  expected_uris = str.split("\n").map { |str| URI(str) }
  expect(@filtered_uris).to eq expected_uris
end