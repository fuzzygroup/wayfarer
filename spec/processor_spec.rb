require "spec_helpers"

describe Schablone::Processor do
  let(:indexer)       { Proc.new {} }
  let(:router)        { Router.new }
  subject(:processor) { Processor.new(router) }

  before do
    router.register_scraper(:foo, &Proc.new {})
    router.draw(:foo) { host "example.com" }
  end

  describe "#step" do
    let(:uri) { URI("http://example.com") }

    before do
      processor.navigator.stage(uri)
      processor.navigator.cycle
    end

    it "halts" do
      processor.run
      expect(processor.halted?).to be true
    end

    it "caches URIs" do
      processor.step
      expect(processor.navigator.cached_uris).to eq [uri]
    end

    it "stages URIs" do
      router.register_scraper(:foo, &Proc.new { visit("http://google.com") })
      processor.step
      expect(processor.navigator.current_uris).to eq [URI("http://google.com")]
    end
  end
end
