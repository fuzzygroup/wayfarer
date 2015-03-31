require "benchmark"
require "uri"
require "faker"

require_relative "../lib/schablone"

haystack = 10_000.times.map { URI(Faker::Internet.url) }
needles = []
needles.concat 2_500.times.map { URI(Faker::Internet.url) }
needles.concat 2_500.times.map { haystack.sample }

store = Schablone::URIStore.new
array = []
set = Set.new([])

haystack.each do |uri|
  store << uri
  array << uri
  set << uri
end

Benchmark.bmbm(18) do |bm|
  bm.report("URIStore#include?") do
    needles.each do |needle|
      store.include?(needle)
    end
  end

  bm.report("Set#include?") do
    needles.each do |needle|
      set.include?(needle)
    end
  end
end
