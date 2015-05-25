require "spec_helpers"

describe Schablone::Processor do
  let(:indexer)       { Proc.new {} }
  let(:router)        { Router.new }
  subject(:processor) { Processor.new(router) }

  before do
    router.register_scraper(:foo, &Proc.new {})
    router.draw(:foo) { host "example.com" }
  end

  describe "#run" do
    it "halts" do
      processor.run
      expect(processor.halted?).to be true
    end

    it "caches URIs" do
      processor.navigator.stage(uri = URI("http://example.com"))
      processor.navigator.cycle
      processor.run
      expect(processor.navigator.cached_uris).to eq [uri]
    end
  end
end
