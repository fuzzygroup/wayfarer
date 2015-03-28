require "benchmark"
require "faker"
require "uri"

require_relative "../lib/schablone"

processor = Schablone::Processor.new(nil, nil, nil)

haystack = 10000.times.map { URI(Faker::Internet.url) }
haystack.each { |uri| processor.send(:cache, uri) }
needle = haystack.sample

Benchmark.bm(10) do |bm|
  bm.report("#cached?") { processor.send(:cached?, needle) }
end