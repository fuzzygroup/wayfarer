require "spec_helpers"

describe Schablone::Indexer do
  let(:router)      { Router.new }
  let(:processor)   { Processor.new(router) }
  let(:adapter)     { Object.new }
  let(:page)        { fetch_page("http://example.com") }
  let(:params)      { {} }
  subject(:indexer) { Indexer.new(processor, adapter, page, params) }

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
      }.to change { processor.navigator.staged_uris.count }.by(2)
    end
  end

  describe "#halt" do
    it "halts the Processor" do
      indexer.instance_variable_set(:@processor, processor = spy())
      indexer.send(:halt)
      expect(processor).to have_received(:halt)
    end
  end

  describe "#evaluate" do
    it "evaluates the Proc in its instance context" do
      this = nil
      indexer.evaluate Proc.new { this = self }
      expect(this).to be indexer
    end
  end
end
