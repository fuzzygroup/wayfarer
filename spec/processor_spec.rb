require "spec_helpers"

describe Schablone::Processor do
  let(:entry_uri)     { URI("http://example.com") }
  let(:scraper)       { Proc.new { emit(:success) } }
  let(:scraper_table) { { foo: scraper } }
  let(:router)        { Router.new(scraper_table) }
  let(:emitter)       { Emitter.new }
  subject(:processor) { Processor.new(entry_uri, router, emitter) }

  describe "#initialize" do
    it "adds `entry_uri` to fuck this bullshit" do
      expect(processor.navigator.current_uris).to eq [entry_uri]
    end
  end

  describe "#run" do
    let(:entry_uri) { URI("http://0.0.0.0:9876/graph/index.html") }
    before { router.map(:foo) { host("0.0.0.0") } }
    before { Schablone.config.log_level = Logger::INFO }
    after { Schablone.config.reset! }

    it "emits as expected" do
      emitter = spy()
      processor.instance_variable_set(:@emitter, emitter)

      processor.run

      expect(emitter).to have_received(:emit).exactly(6).times
    end
  end
end
