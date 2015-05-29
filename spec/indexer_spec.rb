require "spec_helpers"

describe Schablone::Indexer do
  let(:router)  { Router.new }
  let(:adapter) { NetHTTPAdapter.instance }
  let(:page)    { fetch_page(test_app("/hello_world")) }
  let(:params)  { {} }

  let!(:processor)    { Celluloid::Actor[:processor] = Processor.new(router) }
  let!(:navigator)    { Celluloid::Actor[:navigator] = Navigator.new }

  subject(:indexer) { Indexer.new(router, adapter, page, params) }

  describe "::helpers" do
    it "allows defining helper methods" do
      expect {
        Indexer.helpers { def foobar; end }
      }.to change { indexer.methods.count }.by(1)
    end

    it "accepts Modules" do
      module_a = Module.new { def alpha; end }
      module_b = Module.new { def beta; end }

      expect {
        Indexer.helpers(module_a, module_b)
      }.to change { indexer.methods.count }.by(2)
    end
  end

  describe "#visit" do
    it "stages URIs" do
      expect {
        indexer.send(:visit, "http://google.com", "http://yahoo.com")
      }.to change { navigator.staged_uris.count }.by(2)
    end
  end

  describe "#halt" do
    it "halts the Processor" do
      indexer.send(:halt)
      expect(processor).not_to be_alive
    end
  end

  describe "#evaluate" do
    it "allows calling #adapter, #page and #params" do
      adapter = page = params = nil

      payload = Proc.new do
        adapter = self.adapter
        page    = self.page
        params  = self.params
      end

      indexer.evaluate(payload)

      expect(adapter).to be_a NetHTTPAdapter
      expect(page).to be_a Page
      expect(params).to be_a Hash
    end
  end

  describe "#index" do
    it "evaluates payloads" do
      call_times = 0
      router.register_payload(:bar) { call_times += 1 }
      router.register_payload(:qux) { call_times += 1 }

      router.draw(:bar, host: "example.com")
      
    end
  end
end
