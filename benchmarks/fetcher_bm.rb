require "benchmark"
require "uri"

require_relative "../lib/schablone"

fetcher = Schablone::Fetcher.new
uri = URI("http://0.0.0.0:9876/graph/index")

Benchmark.bmbm(10) do |bm|
  bm.report("#fetch") { fetcher.fetch(uri) }
end
